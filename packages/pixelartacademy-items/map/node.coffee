AE = Artificial.Everywhere
AM = Artificial.Mirage
LOI = LandsOfIllusions
PAA = PixelArtAcademy

Vocabulary = LOI.Parser.Vocabulary
Directions = Vocabulary.Keys.Directions

class PAA.Items.Map.Node extends AM.Component
  @register 'PixelArtAcademy.Items.Map.Node'
  
  onCreated: ->
    super

    location = @data()

    @map = @ancestorComponent PAA.Items.Map

    @size = new ComputedField =>
      location = @data()
      return unless mapSize = @map.size()

      # Get the map width in game pixels.
      scale = LOI.adventure.interface.display.scale()
      mapWidth = mapSize.width() / scale
      mapHeight = mapSize.height() / scale

      if @map.bigMap() or not @map.miniMap()
        nodeGap = 19
        outerNodeGap = 9

        # Nodes should take 1/4 of the big map width.
        width = Math.floor mapWidth / 4
        height = 25

      else
        nodeGap = 9
        outerNodeGap = 3

        # Nodes should take 1/3 of the mini-map width, with two gaps in between.
        width = Math.floor (mapWidth - 2 * nodeGap) / 3
        height = 17

      center =
        left: mapWidth / 2
        top: mapHeight / 2

      left = center.left - width * 0.5
      top = center.top - height * 0.5

      switch location.direction
        when Directions.Northwest, Directions.West, Directions.Southwest
          left = center.left - width * 1.5 - nodeGap

        when Directions.Northeast, Directions.East, Directions.Southeast
          left = center.left + width * 0.5 + nodeGap

      switch location.direction
        when Directions.Northwest, Directions.North, Directions.Northeast
          top = center.top - height * 1.5 - nodeGap

        when Directions.Southwest, Directions.South, Directions.Southeast
          top = center.top + height * 0.5 + nodeGap

      if location.specialDirection and not location.direction
        # Position in the north/south spot.
        switch location.specialDirection
          when Directions.Up, Directions.In
            top = center.top - height * 1.5 - nodeGap

          when Directions.Down, Directions.Out
            top = center.top + height * 0.5 + nodeGap

        # Move out of the north/south spot into top/bottom row if there is no space there.
        switch location.specialDirection
          when Directions.Up
            moveUp = true if @map.northLocation() or location.specialPositioning and @map.anyNorthLocations()

          when Directions.In
            moveUp = true if @map.northLocation() or @map.specialLocations()[Directions.Up] and not location.specialPositioning

          when Directions.Down
            moveDown = true if @map.southLocation() or location.specialPositioning and @map.anySouthLocations()

          when Directions.Out
            moveDown = true if @map.southLocation() or @map.specialLocations()[Directions.Down]

        top -= height + nodeGap + outerNodeGap if moveUp
        top += height + nodeGap + outerNodeGap if moveDown

        # Handle special positioning when both stairs and exits appear in the same row side-to-side.
        if location.specialPositioning
          switch location.specialDirection
            when Directions.Up, Directions.Down
              # Move to the left side.
              left = center.left - width - nodeGap * 0.5

            when Directions.In, Directions.Out
              # Move to the right side.
              left = center.left + nodeGap * 0.5

      new AE.Rectangle left, top, width, height
    ,
      EJSON.equals

  onRendered: ->
    super

    Meteor.setTimeout =>
      @$('.pixelartacademy-items-map-node')?.addClass('visible')
    ,
      500

  name: ->
    location = @data()
    _.deburr location.avatar.shortName()

  direction: ->
    location = @data()

    # Special directions have priority except for east/west.
    unless location.direction in [Directions.East, Directions.West]
      direction = location.specialDirection or location.direction

    else
      direction = location.direction or location.specialDirection

    return unless direction

    phrases = LOI.adventure.parser.vocabulary.getPhrases direction

    # Find the shortest phrase.
    phrases = _.sortBy phrases, (phrase) => phrase.length

    phrases[0]

  directionClass: ->
    location = @data()

    return 'no-direction' unless location.direction

    @_makeDirectionClass location.direction

  specialDirectionClass: ->
    location = @data()

    @_makeDirectionClass location.specialDirection

  _makeDirectionClass: (directionId) ->
    return unless directionId

    # Remove "Direction." part
    directionClass = directionId.substring directionId.indexOf('.') + 1

    _.toLower directionClass

  currentClass: ->
    location = @data()

    'current' if location.current

  specialPositioningClass: ->
    location = @data()

    'special-positioning' if location.specialPositioning

  nodeStyle: ->
    return unless size = @size()?.toDimensions()

    width: "#{size.width}rem"
    height: "#{size.height}rem"
    top: "#{size.top}rem"
    left: "#{size.left}rem"
