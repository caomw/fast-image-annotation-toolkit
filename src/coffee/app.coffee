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
        context = canvas.getContext('2d')
        img = new Image
        img.src = URL.createObjectURL(e.target.files[0])
        img.onload = ->
            h = img.height
            w = img.width
            if not (w < canvas.width && h < canvas.height)
                if w < h
                    w = w/h*canvas.height
                    h = canvas.height
                else
                    h = h/w*canvas.width
                    w = canvas.width
            context.drawImage(img, 0, 0, w, h)

    init = ->
        canvas = new Canvas($('#my-canvas'))
        Window.canvas = canvas
    init()
    @
