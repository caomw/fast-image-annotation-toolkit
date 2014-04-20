class Shape
    constructor: (@canvas, @x, @y, @w, @h, @color = '#AAA') ->

    draw: (canvas = @canvas) ->
        canvas.context.fillStyle = @color
        canvas.context.fillRect @x, @y, @w, @h

    contains: (mx, my) ->
        (@x <= mx) and (@x + @w >= mx) and
        (@y <= my) and (@y + @h >= my)

    isOutsideCanvas: (canvas = @canvas) ->
        return @x > canvas.width or @y > canvas.height or @x + @w < 0 or @y + @h < 0

    setCenter: (cx, cy) ->
        @x = cx - @w/2
        @y = cy - @h/2


class ResizableRectangle extends Shape
    constructor: (@canvas, @x, @y, @w, @h, @color = '#AAA') ->
        @selectionHandles = []
        for i in [0..7]
            @selectionHandles.push (new Rectangle @canvas)

    draw: (canvas = @canvas) ->
        if not @isOutsideCanvas canvas
            canvas.context.fillStyle = @color
            canvas.context.fillRect @x, @y, @w, @h

    drawSelectionHandles: (canvas = @canvas) ->
        for handle, i in @selectionHandles
            [x, y] =
                [[@x, @y], [@x + @w/2, @y], [@x + @w, @y], [@x, @y + @h/2],
                    [@x + @w, @y + @h/2], [@x, @y + @h], [@x + @w/2, @y + @h],
                    [@x + @w, @y + @h]][i]
            handle.setCenter x, y
            handle.draw canvas


class Rectangle extends Shape
    constructor: (@canvas, @x=0, @y=0, @w=10, @h=10, @color='darkred') ->


class Canvas
    constructor: (@canvas) ->
        # @canvas here is a jQuery object
        @width = @canvas[0].width
        @height = @canvas[0].height
        @context = @canvas[0].getContext('2d')

        html = document.body.parentNode
        @htmlTop = html.offsetTop
        @htmlLeft = html.offsetLeft
        @stylePaddingLeft = @canvas.cssNumber('padding-left')
        @stylePaddingTop = @canvas.cssNumber('padding-top')
        @styleBorderLeft = @canvas.cssNumber('border-left-width')
        @styleBorderTop = @canvas.cssNumber('border-top-width')

        @isValid = false
        @shapes = []
        @isDragging = false
        @isResizing = false
        @selection = null
        @dragoffx = 0
        @dragoffy = 0

        canvas = @

        #prevent text select outside canvas on double-click
        @canvas[0].onselectstart = (e) ->
            e.preventDefault()
            false

        @canvas.mousedown (e) ->
            mouse = canvas.getMouse(e)
            mx = mouse.x
            my = mouse.y
            shapes = canvas.shapes

            canvas.isValid = false

            for shape in canvas.shapes by -1
                for handle in shape.selectionHandles
                    if handle.contains(mx, my)
                        canvas.isResizing = true
                        canvas.resizingDirection = handle.pos
                        canvas.resizingShape = shape
                        return @
                if shape.contains(mx, my)
                    canvas.dragoffx = mx - shape.x
                    canvas.dragoffy = my - shape.y
                    canvas.isDragging = true
                    canvas.selection = shape
                    return @

            # not returned means no selection
            canvas.selection = null

        @canvas.mousemove (e) ->
            if canvas.isDragging
                mouse = canvas.getMouse e
                canvas.selection.x = mouse.x - canvas.dragoffx
                canvas.selection.y = mouse.y - canvas.dragoffy
                canvas.isValid = false

        @canvas.mouseup (e) ->
            canvas.isDragging = false
            canvas.isResizing = false

        @canvas.dblclick (e) ->
            mouse = canvas.getMouse e
            canvas.addShape new ResizableRectangle canvas, mouse.x-10, mouse.y-10, 20, 20,
                            'rgba(0, 255, 0, .6)'

        @selectionColor = '#CC0000'
        @selectionWidth = 2
        @interval = 30
        setInterval (-> canvas.draw()), canvas.interval

    addShape: (shape) ->
        @shapes.push shape
        @isValid = false

    clear: () ->
        @context.clearRect 0, 0, this.width, this.height

    draw: ->
        if not @isValid
            @clear()

            for shape in @shapes
                if not shape.isOutsideCanvas()
                    shape.draw()

            if @selection
                @context.strokeStyle = @selectionColor
                @context.lineWidth = @selectionWidth
                @context.strokeRect @selection.x, @selection.y,
                                    @selection.w, @selection.h
                @selection.drawSelectionHandles()

            @isValid = true
        @

    getMouse: (e) ->
        element = @canvas[0]
        offsetX = offsetY = 0

        while element.offsetParent?
            offsetX += element.offsetLeft
            offsetY += element.offsetTop
            element = element.offsetParent

        offsetX += @stylePaddingLeft + @styleBorderLeft + @htmlLeft
        offsetY += @stylePaddingTop + @styleBorderTop + @htmlTop

        mx = e.pageX - offsetX
        my = e.pageY - offsetY

        {x: mx, y: my}

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
