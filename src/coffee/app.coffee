#_require ./inc/helpers.coffee
#_require ./inc/canvas.coffee
#_require ./inc/keyboard-handler.coffee

$ ->
    $.fn.cssNumber = (property) ->
        value = parseInt @css(property), 10
        if isNaN value then 0 else value

    $('.input-append.btn').click ->
        $('input[id=file]').click()
    $('input[id=file]').change (e) ->
        $('#selected-file').val $(this).val()
        canvas = Window.canvas
        img = new Image
        img.src = URL.createObjectURL(e.target.files[0])
        img.onload = ->
            h = img.height
            w = img.width
            maxW = canvas.width * 0.7
            maxH = canvas.height * 0.7
            if not (w < maxW && h < maxH)
                if w < h
                    w = w/h*maxH
                    h = maxH
                else
                    h = h/w*maxW
                    w = maxW
            img.width = w
            img.height = h
            canvas.addImage img

    init = ->
        canvas = new Canvas $ '#my-canvas'
        Window.canvas = canvas
    init()
    @
