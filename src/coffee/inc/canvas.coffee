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
                for handle, i in shape.selectionHandles
                    if handle.contains(mx, my)
                        canvas.isResizing = true
                        canvas.resizingDirection = i
                        canvas.resizeStartPosition = [handle.x, handle.y]
                        canvas.resizeStartShapeInfo = [shape.x, shape.y,
                                                       shape.w, shape.h]
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
            else if canvas.isResizing
                mouse = canvas.getMouse e
                dir = canvas.resizingDirection
                [x, y] = canvas.resizeStartPosition
                [dx, dy] = [mouse.x - x, mouse.y - y]
                [x, y, w, h] = canvas.resizeStartShapeInfo

                @style.cursor = ['nw-resize', 'n-resize', 'ne-resize',
                                 'w-resize',  'e-resize', 'sw-resize',
                                 's-resize',  'se-resize'][dir]

                canvas.resizingShape.resize(dir, x, y, w, h, dx, dy)
                canvas.isValid = false


        @canvas.mouseup (e) ->
            canvas.isDragging = false
            canvas.isResizing = false
            @style.cursor = 'auto'

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
