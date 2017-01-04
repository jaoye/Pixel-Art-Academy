AB = Artificial.Babel
AE = Artificial.Everywhere
AM = Artificial.Mirage
LOI = LandsOfIllusions

Nodes = LOI.Adventure.Script.Nodes

class LOI.Adventure.Interface.Text extends LOI.Adventure.Interface
  @register 'LandsOfIllusions.Adventure.Interface.Text'

  introduction: ->
    location = @location()
    return unless location
    
    if location.constructor.visited()
      fullName = location.avatar.fullName()
      return unless fullName

      # We've already visited this location so simply return the full name.
      "#{_.upperFirst fullName}."

    else
      # It's the first time we're visiting this location in this session so show the full description.
      @_formatOutput location.avatar.description()
      
  exits: ->
    exits = @location()?.exits()
    return [] unless exits

    # Generate a unique set of IDs from all directions (some directions might lead to same location).
    exits = _.uniq _.values exits
    exits = _.without exits, null

    console.log "Displaying exits", exits if LOI.debug

    exits

  exitName: ->
    exitLocationId = @currentData()
    location = @location()

    # Find exit's location name.
    subscriptionHandle = location.exitsTranslationSubscriptions()[exitLocationId]
    return unless subscriptionHandle?.ready()

    key = LOI.Avatar.translationKeys.shortName
    translated = AB.translate subscriptionHandle, key

    console.log "Displaying exit name for", key, "translated", translated if LOI.debug

    translated.text

  things: ->
    location = @location()

    location.thingInstances thingId for thingId in location.things()

  showCommandLine: ->
    # Show command line unless we're displaying a dialog.
    not @showDialogSelection()

  showDialogSelection: ->
    # Wait if we're paused.
    return if @waitingKeypress()

    # Show the dialog selection when we have some choices available.
    return unless options = @dialogSelection.dialogLineOptions()

    # After the new choices are re-rendered, scroll down the narrative.
    Tracker.afterFlush => @narrative.scroll()

    options

  activeDialogOptionClass: ->
    option = @currentData()

    'active' if option is @dialogSelection.selectedDialogLine()

  showInventory: ->
    true

  activeItems: ->
    # Active items render their UI and can be any non-deactivated item in the inventory or at the location.
    items = _.flatten [
      @options.adventure.inventory.values()
      _.filter @options.adventure.currentLocation().thingInstances.values(), (thing) => thing instanceof LOI.Adventure.Item
    ]

    activeItems = _.filter items, (item) => not item.deactivated()

    # Also add _id field to help #each not re-render things all the time.
    item._id = item.id() for item in items

    console.log "Text interface is displaying active items", activeItems if LOI.debug

    activeItems

  inventoryItems: ->
    items = _.filter @options.adventure.inventory.values(), (item) -> not item.state().doNotDisplay

    console.log "Text interface is displaying inventory items", items if LOI.debug

    items

  showDescription: (thing) ->
    @narrative.addText thing.avatar?.description()

  caretIdleClass: ->
    'idle' if @commandInput.idle()

  waitingKeypress: ->
    @_pausedNode()

  narrativeLine: ->
    lineText = @currentData()

    @_formatOutput lineText
    
  _formatOutput: (text) ->
    return unless text

    # WARNING: The output of this function should be HTML escaped
    # since the results will be directly injected with triple braces.
    text = AM.HtmlHelper.escapeText text

    # Create color spans.
    text = text.replace /%c#([\da-f]{6})(.*?)%%/g, '<span style="color: #$1">$2</span>'

    # Extract commands between underscores.
    text = text.replace /_(.*?)_/g, '<span class="command">$1</span>'

    text

  active: ->
    # The text interface is active unless there are any modal dialogs.
    not @options.adventure.modalDialogs().length

  # Use to get back to the initial state with full location description.
  resetInterface: ->
    @narrative?.clear()
    @location().constructor.visited false

    Tracker.afterFlush =>
      @narrative.scroll()

  events: ->
    super.concat
      'wheel': @onWheel
      'wheel .scrollable': @onWheelScrollable
      'mouseenter .command': @onMouseEnterCommand
      'mouseleave .command': @onMouseLeaveCommand
      'click .command': @onClickCommand
      'mouseenter .exits .exit .name': @onMouseEnterExit
      'mouseleave .exits .exit .name': @onMouseLeaveExit
      'click .exits .exit .name': @onClickExit

  onMouseEnterCommand: (event) ->
    @hoveredCommand $(event.target).text()

  onMouseLeaveCommand: (event) ->
    @hoveredCommand null

  onClickCommand: (event) ->
    @_executeCommand @hoveredCommand()
    @hoveredCommand null

  onMouseEnterExit: (event) ->
    @hoveredCommand "GO TO #{$(event.target).text()}"

  onMouseLeaveExit: (event) ->
    @hoveredCommand null

  onClickExit: (event) ->
    @_executeCommand @hoveredCommand()
    @hoveredCommand null
