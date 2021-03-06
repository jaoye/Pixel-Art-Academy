AB = Artificial.Babel
AM = Artificial.Mirage
LOI = LandsOfIllusions

Vocabulary = LOI.Parser.Vocabulary

class LOI.Parser.DescriptionListener extends LOI.Adventure.Listener
  onCommand: (commandResponse) ->
    currentPhysicalThings = LOI.adventure.currentPhysicalThings()

    for thing in currentPhysicalThings
      do (thing) ->
        commandResponse.onPhrase
          form: [[Vocabulary.Keys.Verbs.LookAt, Vocabulary.Keys.Verbs.WhatIs, Vocabulary.Keys.Verbs.WhoIs], thing.avatar]
          action: =>
            LOI.adventure.showDescription thing
