#_require ./inc/helpers.coffee
#_require ./inc/components/canvas/canvas.coffee
#_require ./inc/components/range-input.coffee
#_require ./inc/components/file-input.coffee
#_require ./inc/keyboard-handler.coffee

$ ->

    init = ->
        Window.canvas = new Canvas $ '#my-canvas'
        Window.fileInput = new FileInput $('.file-input'), Window.canvas.addImage
        Window.rangeSlider = new RangesSlider $('.range-input'), Window.canvas.setImageOrientation

    init()
    @
