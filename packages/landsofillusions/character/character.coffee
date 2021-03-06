AB = Artificial.Babel
AM = Artificial.Mummification
LOI = LandsOfIllusions
RA = Retronator.Accounts

class LOI.Character extends AM.Document
  @id: -> 'LandsOfIllusions.Character'
  # user: the owner of this character
  #   _id
  #   displayName
  #   publicName
  # ownerName: public name of the owner of this character
  # archivedUser: the owner, archived on retirement of the character
  #   _id
  # debugName: auto-generated best translation of the full name of this character for debugging (do not use in the game!).
  # avatar: information for the representation of the character
  #   fullName: how the character is named
  #     _id
  #     translations
  #   pronouns: enumeration of the gender of pronouns used by the character (Feminine/Masculine/Neutral).
  #   color: character's favorite color as used in the world, for example, in dialogs
  #     hue: ramp index in the Atari 2600 palette
  #     shade: relative shade from -2 to +2
  #   body: avatar data for character's body representation
  #   outfit: avatar data for character's current clothes/accessories
  # behavior: avatar data for character's behavior design
  # designApproved: whether the character has finished the design stage
  # behaviorApproved: whether the character has finished the behavior stage
  # activated: whether the character has been deployed in the world
  @Meta
    name: @id()
    fields: =>
      user: @ReferenceField RA.User, ['displayName', 'publicName'], false, 'characters', ['displayName', 'avatar.fullName', 'activated']
      ownerName: @GeneratedField 'self', ['user'], (character) ->
        ownerName = character.user?.publicName or null
        [character._id, ownerName]
      debugName: @GeneratedField 'self', ['avatar'], (character) ->
        displayName = character.avatar?.fullName?.translations?.best?.text or null
        [character._id, displayName]
      avatar:
        fullName: @ReferenceField AB.Translation, ['translations'], false
        shortName: @ReferenceField AB.Translation, ['translations'], false
  
  # Methods

  @insert: @method 'insert'
  @removeUser: @method 'removeUser'

  @updateName: @method 'updateName'
  @updatePronouns: @method 'updatePronouns'
  @updateColor: @method 'updateColor'
  @updateAvatarBody: @method 'updateAvatarBody'
  @updateAvatarOutfit: @method 'updateAvatarOutfit'
  @updateBehavior: @method 'updateBehavior'

  @approveDesign: @method 'approveDesign'
  @approveBehavior: @method 'approveBehavior'
  @activate: @method 'activate'

  # Subscriptions

  @forId: @subscription 'forId'
  @forCurrentUser: @subscription 'forCurrentUser'
  @activatedForCurrentUser: @subscription 'activatedForCurrentUser'

  # Singletons

  @instances = {}
  
  @getInstance: (id) ->
    return unless id

    unless @instances[id]
      Tracker.nonreactive =>
        @instances[id] = new @Instance id

    @instances[id]

  constructor: ->
    super

    # Create an avatar object so we can use its methods.
    @_avatar = new @constructor.Avatar @

  # Avatar pass-through methods

  name: -> @_avatar.fullName()
  colorObject: (relativeShade) -> @_avatar.colorObject relativeShade
