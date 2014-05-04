#_require ./inc/helpers.coffee
#_require ./inc/components/canvas/canvas.coffee
#_require ./inc/components/range-input.coffee
#_require ./inc/components/file-input.coffee
#_require ./inc/components/sidebar.coffee
#_require ./inc/components/labels.coffee
#_require ./inc/keyboard-handler.coffee
#_require ./inc/image-manager.coffee

$ ->
    init = ->
        Window.sidebar = new SideBar $('.sidebar')
        Window.canvas = new Canvas $('#my-canvas'), Window.sidebar.setMetaData
        Window.imageManager = new ImageManager Window.canvas.addImage, Window.sidebar.setFilename
        Window.fileInput = new FileInput $('.file-input'), Window.imageManager.addImages
        Window.rangeSlider = new RangesSlider $('.range-input'), Window.canvas.setImageOrientation
        Window.labels = new Labels $('input.labels')

    init()
    @
