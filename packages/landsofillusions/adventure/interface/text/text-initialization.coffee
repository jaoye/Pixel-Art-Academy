AE = Artificial.Everywhere
AM = Artificial.Mirage
LOI = LandsOfIllusions

class LOI.Adventure.Interface.Text extends LOI.Adventure.Interface.Text
  onCreated: ->
    super

    console.log "Text interface is being created." if LOI.debug

    # Create pixel scaling display.
    @display = new AM.Display
      safeAreaWidth: 320
      safeAreaHeight: 240
      maxDisplayWidth: 480
      maxDisplayHeight: 640
      minScale: 2
      minAspectRatio: 1/2
      maxAspectRatio: 2
      debug: false

    @narrative = new LOI.Adventure.Interface.Components.Narrative
      textInterface: @

    @commandInput = new LOI.Adventure.Interface.Components.CommandInput
      interface: @
      onEnter: => @onCommandInputEnter()

    @dialogSelection = new LOI.Adventure.Interface.Components.DialogSelection
      interface: @
      onEnter: => @onDialogSelectionEnter()

    @hoveredCommand = new ReactiveField null

    # Node handling must get initialized before handlers, since the latter depends on it.
    @initializeNodeHandling()
    @initializeHandlers()

  onRendered: ->
    super

    console.log "Rendering text interface." if LOI.debug

    @initializeScrolling()

    # Resize on viewport, fullscreen, and illustration height changes.
    @autorun =>
      @display.viewport()
      AM.Window.isFullscreen()
      @options.adventure.currentLocation()?.illustrationHeight?()

      Tracker.afterFlush =>
        @resize()

  onDestroyed: ->
    super

    console.log "Destroying text interface." if LOI.debug

    @commandInput.destroy()
    @dialogSelection.destroy()

    $(window).off '.text-interface'

    # Clean up body height that was set from resizing.
    $('body').css height: ''
