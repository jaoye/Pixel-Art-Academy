AB = Artificial.Babel
LOI = LandsOfIllusions

# Data interface that provides the game representation of a thing.
class LOI.Avatar
  # fullName: how the thing is fully named
  # shortName: how the thing can be quickly referred to
  # description: the description text shown when looking at this thing
  # color: thing's color as used in dialogs
  #   hue: ramp index in the Atari 2600 palette
  #   shade: relative shade from -2 to +2
  @NameAutoCorrectStyle:
    Word: 'Word'
    Name: 'Name'

  @DialogTextTransform:
    Auto: 'Auto'
    Uppercase: 'Uppercase'
    Lowercase: 'Lowercase'

  @DialogDeliveryType:
    Saying: 'Saying'
    Displaying: 'Displaying'

  ready: -> true

  fullName: -> throw new AE.NotImplementedException "You must provide avatar's full name."
  shortName: -> null
  description: -> null
  nameAutoCorrectStyle: -> @constructor.NameAutoCorrectStyle.Word

  color: ->
    hue: LOI.Assets.Palette.Atari2600.hues.grey
    shade: LOI.Assets.Palette.Atari2600.characterShades.normal

  colorObject: (relativeShade) ->
    @constructor.colorObject @color(), relativeShade

  @colorObject: (color, relativeShade = 0) ->
    hue = color?.hue or 0
    shade = color?.shade or 0
    LOI.palette()?.color hue, 6 + shade + relativeShade
