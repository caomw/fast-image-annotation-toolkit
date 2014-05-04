#_require ./inc/helpers.coffee
#_require ./inc/components/canvas/canvas.coffee
#_require ./inc/components/range-input.coffee
#_require ./inc/keyboard-handler.coffee

$ ->
    $('.input-append.btn').click ->
        $('input[id=file]').click()

    $('input[id=file]').change (e) ->
        $('#selected-file').val $(this).val()
        canvas = Window.canvas
        img = new Image
        img.src = URL.createObjectURL(e.target.files[0])
        img.onload = ->
            canvas.addImage img

    init = ->
        Window.canvas = new Canvas $ '#my-canvas'
        Window.rangeSlider = new RangesSlider $('input[id=rangeinput]'), console.log

    init()
    @
