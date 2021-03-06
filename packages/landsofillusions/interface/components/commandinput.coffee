AC = Artificial.Control
AM = Artificial.Mirage
LOI = LandsOfIllusions

class LOI.Interface.Components.CommandInput
  constructor: (@options) ->
    @command = new ReactiveField ""

    # Capture key events.
    $(document).on 'keypress.commandInput', (event) =>
      @onKeyPress event

    $(document).on 'keydown.commandInput', (event) =>
      @onKeyDown event

    console.log "Command input constructed." if LOI.debug

    @idle = new ReactiveField true

    @_resumeIdle = _.debounce =>
      @idle true
    ,
      1000

  destroy: ->
    console.log "Command input destroyed." if LOI.debug

    # Remove key events.
    $(document).off('.commandInput')

  clear: ->
    @command ""

  _notIdle: ->
    @idle false
    @_resumeIdle()

  onKeyPress: (event) ->
    # Don't capture events when interface is not active (some other dialog
    # is blocking it) or when the interface itself is doing something else.
    busyConditions = [
      not @options.interface.active()
      @options.interface.waitingKeypress()
      @options.interface.showDialogSelection()
    ]

    return if _.some busyConditions

    # Ignore control characters.
    charCode = event.which
    return if charCode <= AC.Keys.lastControlCharacter

    character = String.fromCharCode charCode

    command = @command()
    newCommand = "#{command}#{character}"

    @command newCommand

    @_notIdle()

    # Don't let space scroll.
    return false if event.which is AC.Keys.space

  onKeyDown: (event) ->
    interfaceActive = @options.interface.active()

    console.log "Command input detected a key down and is checking if interface is active:", interfaceActive if LOI.debug

    # Don't capture events when interface is not active.
    return unless interfaceActive

    keyCode = event.which

    switch keyCode
      when AC.Keys.backspace
        event.preventDefault()

        command = @command()
        return unless command.length

        newCommand = command.substring 0, command.length - 1
        @command newCommand

        @_notIdle()

      when AC.Keys.enter
        @options?.onEnter?()

    # Trigger event for any key down.
    @options?.onKeyDown?()
