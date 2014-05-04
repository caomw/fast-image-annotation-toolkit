#_require ./inc/helpers.coffee
#_require ./inc/components/canvas/canvas.coffee
#_require ./inc/components/range-input.coffee
#_require ./inc/components/file-input.coffee
#_require ./inc/components/sidebar.coffee
#_require ./inc/keyboard-handler.coffee

$ ->

    init = ->
        Window.sideBar = new SideBar $('.sidebar')
        Window.canvas = new Canvas $('#my-canvas'), Window.sideBar.setMetaData
        Window.fileInput = new FileInput $('.file-input'), Window.canvas.addImage
        Window.rangeSlider = new RangesSlider $('.range-input'), Window.canvas.setImageOrientation

    init()
    @
