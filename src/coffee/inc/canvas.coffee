#_require ./shapes/rectangle.coffee
#_require ./shapes/resizable-rectangle.coffee

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
                for handle, i in shape.selectionHandles
                    if handle.contains mx, my
                        canvas.startResizingShape shape, i, mx, my
                        return @
                if shape.contains mx, my
                    canvas.startMovingShape shape, mx, my
                    return @

            # not returned means no selection
            canvas.selection = null

        @canvas.mousemove (e) ->
            mouse = canvas.getMouse e
            [canvas.mx, canvas.my] = [mouse.x, mouse.y]

            if canvas.isDragging
                canvas.selection.x = canvas.mx - canvas.dragoffx
                canvas.selection.y = canvas.my - canvas.dragoffy
                canvas.isValid = false
            else if canvas.isResizing
                dir = canvas.resizingDirection
                [x, y] = canvas.resizeStartPosition
                [dx, dy] = [canvas.mx - x, canvas.my - y]
                [x, y, w, h] = canvas.resizeStartShapeInfo


                canvas.resizingShape.resize(dir, x, y, w, h, dx, dy)
                canvas.isValid = false


        @canvas.mouseup (e) ->
            canvas.stopMovingAndResizing()

        @selectionColor = '#CC0000'
        @selectionWidth = 2
        @interval = 30
        setInterval (-> canvas.draw()), canvas.interval

    startResizingShape: (shape, direction, startX, startY) ->
        @isResizing = true
        @resizingDirection = direction
        @resizeStartPosition = [startX, startY]
        @resizeStartShapeInfo = [shape.x, shape.y, shape.w, shape.h]
        @resizingShape = shape
        @canvas[0].style.cursor = ['nw-resize', 'n-resize', 'ne-resize',
                        'w-resize',  'e-resize', 'sw-resize',
                        's-resize',  'se-resize'][direction]
        @isValid = false
        @selection = shape

    startMovingShape: (shape, startX, startY) ->
        @dragoffx = startX - shape.x
        @dragoffy = startY - shape.y
        @isDragging = true
        @selection = shape

    stopMovingAndResizing: ->
            @isDragging = false
            @isResizing = false
            @canvas[0].style.cursor = 'auto'

    unselectShape: ->
        @selection = null
        @isValid = false

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
