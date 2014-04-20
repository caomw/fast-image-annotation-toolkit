#_require ./inc/canvas.coffee

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
        canvas = $('#my-canvas')
        s = new Canvas(canvas)
        s.addShape new ResizableRectangle s, 40, 40, 50, 50
        s.addShape new ResizableRectangle s, 60, 140, 40, 60, 'lightskyblue'
        s.addShape new ResizableRectangle s, 80, 150, 60, 30, 'rgba(127, 255, 212, .5)'
        s.addShape new ResizableRectangle s, 125, 80, 30, 80, 'rgba(245, 222, 179, .7)'
    init()
    @
