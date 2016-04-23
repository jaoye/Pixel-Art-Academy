AM = Artificial.Mirage
PAA = PixelArtAcademy

class PAA.PixelBoy.OS extends AM.Component
  @register 'PixelArtAcademy.PixelBoy.OS'

  constructor: ->
    super

  onCreated: ->
    super

    @justOS = FlowRouter.getRouteName() is 'pixelBoy'

    homeScreen = new PAA.PixelBoy.Apps.HomeScreen @

    @apps = [
      new PAA.PixelBoy.Apps.Journal @
      new PAA.PixelBoy.Apps.Calendar @
      new PAA.PixelBoy.Apps.Pico8 @
    ]

    # Create a map for fast retrieval of apps by their url name.
    appsNameMap = _.object ([app.keyName(), app] for app in @apps)
    @appsMap = appsNameMap

    @currentAppKeyName = ComputedField =>
      FlowRouter.getParam('app') or FlowRouter.getParam('parameter2')

    @currentAppPath = ComputedField =>
      FlowRouter.getParam('path') or FlowRouter.getParam('parameter3')

    @currentApp = new ReactiveField null

    @autorun =>
      appKeyName = @currentAppKeyName()

      Tracker.nonreactive =>
        newApp = appsNameMap[appKeyName] or homeScreen
        currentApp = @currentApp()
        
        return if newApp is currentApp
        
        startNewApp = =>
          return unless newApp

          @currentApp newApp
          newApp.activate()

        if currentApp
          currentApp.deactivate =>
            startNewApp()

        else
          startNewApp()

    if @justOS
      # Create pixel scaling display.
      @display = new Artificial.Mirage.Display
        safeAreaWidth: 320
        safeAreaHeight: 240
        minScale: 2

  onRendered: ->
    super

    @$root = if @justOS then $('html') else @$('.pixelboy-os').closest('.os')
    @$root.addClass('pixel-art-academy-style-pixelboy-os')

  onDestroyed: ->
    super

    @$root.removeClass('pixel-art-academy-style-pixelboy-os')

  appPath: (appKeyName, appPath) ->
    appPath = null if appPath instanceof Spacebars.kw
    
    if @justOS
      FlowRouter.path 'pixelBoy',
        app: appKeyName
        path: appPath

    else
      FlowRouter.path 'adventure',
        parameter1: 'pixelboy'
        parameter2: appKeyName
        parameter3: appPath

  go: (appKeyName, appPath) ->
    FlowRouter.go @appPath appKeyName, appPath
