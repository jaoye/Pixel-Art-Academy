LOI = LandsOfIllusions

class LOI.Character.Part.Property.Color extends LOI.Character.Part.Property
  # node
  #   fields
  #     hue
  #       value
  #     shade
  #       value
  constructor: (@options = {}) ->
    super

    @type = 'color'

    return unless @options.dataLocation