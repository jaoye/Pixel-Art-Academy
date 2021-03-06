AM = Artificial.Mummification
AB = Artificial.Babel
LOI = LandsOfIllusions

# Character's implementation of the avatar that takes the data from the character document.
class LOI.Character.Avatar extends LOI.HumanAvatar
  constructor: (characterInstanceOrDocument) ->
    # We allow the avatar to be constructed for the character instance or directly for the document. If we're passing in
    # an instance this creates a full avatar with body and outfit hierarchies. If we're passing the document, this
    # becomes just a shell object for methods performed on the document.
    if characterInstanceOrDocument instanceof LOI.Character.Instance
      @character = characterInstanceOrDocument
      @document = @character.document
      
      # Create the body and outfit data hierarchies first.
      bodyDataField = AM.Hierarchy.create
        templateClass: LOI.Character.Part.Template
        # TODO: We need to set the type somehow different so it's dynamic in the location (test with create template).
        type: LOI.Character.Part.Types.Avatar.Body.options.type
        load: => @_avatar()?.body
        save: (address, value) =>
          LOI.Character.updateAvatarBody @character.id, address, value
  
      outfitDataField = AM.Hierarchy.create
        templateClass: LOI.Character.Part.Template
        type: LOI.Character.Part.Types.Avatar.Outfit.options.type
        load: => @_avatar()?.outfit
        save: (address, value) =>
          LOI.Character.updateAvatarOutfit @character.id, address, value
  
      # Now we can call HumanAvatar's constructor which will turn this data into an actual part hierarchy.
      super {bodyDataField, outfitDataField}
      
    else
      @document = => characterInstanceOrDocument
      
      super {}

  _avatar: ->
    @document()?.avatar

  fullName: ->
    return @_loading() unless avatar = @_avatar()

    avatar.fullName?.translate().text or @_noName()

  shortName: ->
    # Player characters only have one name.
    @fullName()

  pronouns: ->
    @_avatar()?.pronouns or super

  _loading: ->
    return if Meteor.isServer

    AB.translate(@constructor._babelSubscription, 'Loading …').text

  _noName: ->
    return if Meteor.isServer

    @constructor.noName()

  color: ->
    return super unless color = @_avatar()?.color

    hue: color?.hue or LOI.Assets.Palette.Atari2600.hues.grey
    shade: color?.shade or LOI.Assets.Palette.Atari2600.characterShades.normal

  @noNameTranslation: ->
    AB.translation @_babelSubscription, 'No Name'

  @noName: ->
    @noNameTranslation().translate().text

if Meteor.isClient
  Meteor.startup ->
    # Subscribe to the avatar namespace in all languages, so that we can show all translations of "No Name" in the
    # dialogs. We do this because of a limitation in Meteor, where we can't later on request to get all translations
    # (top field), if we subscribed just to some translations (subfields) earlier.
    LOI.Character.Avatar._babelSubscription = AB.subscribeNamespace 'LandsOfIllusions.Character.Avatar',
      # Null subscribes to all languages.
      languages: null
