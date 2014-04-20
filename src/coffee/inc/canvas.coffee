#_require ./helpers.coffee
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
            [mx, my] = [mouse.x, mouse.y]
            canvas.isValid = false
            canvas.isDragging = true

            # check all selection handles and borders first
            for shape in canvas.shapes by -1
                for handle, i in shape.selectionHandles
                    if handle.contains mx, my
                        return canvas.startResizingShape shape, i, mx, my
                if shape.isOnBorder mx, my
                    return canvas.startMovingShape shape, mx, my

            for shape in canvas.shapes by -1
                if shape.contains mx, my
                    return canvas.startMovingShape shape, mx, my

            # not returned means no selection
            canvas.unselectShape()
            canvas.refresh()

        @canvas.mousemove (e) ->
            mouse = canvas.getMouse e
            [canvas.mx, canvas.my] = [mouse.x, mouse.y]

            if canvas.isResizing
                dir = canvas.resizingDirection
                [x, y] = canvas.resizeStartPosition
                [dx, dy] = [canvas.mx - x, canvas.my - y]
                [x, y, w, h] = canvas.resizeStartShapeInfo

                canvas.resizingShape.resize(dir, x, y, w, h, dx, dy)
                canvas.isValid = false

            else if canvas.isDragging
                if canvas.selection
                    canvas.selection.x = canvas.mx - canvas.dragoffx
                    canvas.selection.y = canvas.my - canvas.dragoffy
                    canvas.isValid = false
                else
                    shape = canvas.addShape()
                    canvas.startResizingShape shape, 0, canvas.mx, canvas.my


            canvas.refresh() if not canvas.isValid


        @canvas.mouseup (e) ->
            canvas.stopMovingAndResizing()
            canvas.refresh()

        @selectionColor = '#CC0000'
        @selectionWidth = 2

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
        @selectShape shape

    startMovingShape: (shape, startX, startY) ->
        @dragoffx = startX - shape.x
        @dragoffy = startY - shape.y
        @selectShape shape

    stopMovingAndResizing: ->
        if @isResizing
            # Give smaller shapes higher selection priority
            @shapes.sort (shapeA, shapeB) ->
                shapeA.getArea() < shapeB.getArea()
        @isDragging = false
        @isResizing = false
        @canvas[0].style.cursor = 'auto'

    selectShape: (shape) ->
        @selection = shape

    unselectShape: ->
        if @selection
            @selection = null
            @isValid = false

    addShape: (x=@mx, y=@my, shape=null) ->
        if not shape
            shape = new ResizableRectangle @, x, y, 0, 0,
                    'rgba(255, 0, 0, 1)'
        @shapes.push shape

        @isValid = false
        shape

    removeShape: (shape) ->
        @shapes.remove shape
        @selection = null if @selection == shape
        @stopMovingAndResizing()
        @isValid = false

    clear: () ->
        @context.clearRect 0, 0, @width, @height

    refresh: ->
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
