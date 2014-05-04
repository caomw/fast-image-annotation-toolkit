#_require ./../../helpers.coffee
#_require ./shapes/rectangle.coffee
#_require ./shapes/resizable-rectangle.coffee

class Canvas
    constructor: (@canvas) ->
        # @canvas is a jQuery object
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

        #prevent text select outside canvas on double-click
        @canvas[0].onselectstart = (e) =>
            e.preventDefault()
            false

        @canvas.mousedown (e) =>
            mouse = @getMouse(e)
            [mx, my] = [mouse.x, mouse.y]
            @isValid = false
            @isDragging = true

            # check all selection handles and borders first
            for shape in @shapes by -1
                for handle in shape.selectionHandles
                    if handle.contains mx, my
                        @changeCursor handle.getCursor()
                        return @startResizingShape shape,
                            handle.getResizeDirection(), mx, my
                if shape.isOnBorder mx, my
                    return @startMovingShape shape, mx, my

            for shape in @shapes by -1
                if shape.contains mx, my
                    return @startMovingShape shape, mx, my

            # not returned means no selection
            @unselectShape()
            @refresh()

        @canvas.mousemove (e) =>
            mouse = @getMouse e
            [@mx, @my] = [mouse.x, mouse.y]

            if @isResizing
                dir = @resizingDirection
                [x, y] = @resizeStartPosition
                [dx, dy] = [@mx - x, @my - y]
                [x, y, w, h] = @resizeStartShapeInfo

                @resizingShape.resize dir, x, y, w, h, dx, dy
                @isValid = false

            else if @isDragging
                if @selection
                    @selection.x = @mx - @dragoffx
                    @selection.y = @my - @dragoffy
                    @isValid = false
                else
                    shape = @addShape()
                    @startResizingShape shape, 'top-left',
                                              @mx, @my

            @refresh() if not @isValid

        @canvas.mouseup (e) =>
            @stopMovingAndResizing()
            @refresh()

        @selectionColor = '#CC0000'
        @selectionWidth = 2

    startResizingShape: (shape, direction, startX, startY) ->
        @isResizing = true
        @resizingDirection = direction
        @resizeStartPosition = [startX, startY]
        @resizeStartShapeInfo = [shape.x, shape.y, shape.w, shape.h]
        @resizingShape = shape
        @isValid = false
        @selectShape shape

    changeCursor: (type) ->
        @canvas[0].style.cursor = type

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

    addShape: (shape=null) ->
        if not shape
            shape = new ResizableRectangle @, @mx, @my, 0, 0,
                    'rgba(255, 0, 0, 1)'
        @shapes.push shape

        @isValid = false
        shape

    drawRotatedImage: (imageObj) ->
        image = imageObj['image']
        width = imageObj['width']
        height = imageObj['height']
        orientation = imageObj['orientation']
        @context.save()
        @context.translate @width/2, @height/2
        @context.rotate orientation*Math.PI/180
        @context.drawImage image, -width/2, -height/2, width, height
        @context.restore()

    addImage: (image) =>
        @image =
            'image':image
            'orientation':0
            'width':@width * image.width/image.height/2
            'height':@height/2
        @drawRotatedImage @image
        @isValid = false
        @refresh()

    removeShape: (shape) ->
        @shapes.remove shape
        @selection = null if @selection == shape
        @stopMovingAndResizing()
        @isValid = false

    clear: () ->
        @context.clearRect 0, 0, @width, @height

    refresh: ->
        if not @isValid
            @isValid = true
            @clear()

            if @image?
                @drawRotatedImage @image

            for shape in @shapes
                if not shape.isOutsideCanvas()
                    shape.draw()

            if @selection
                @context.strokeStyle = @selectionColor
                @context.lineWidth = @selectionWidth
                @context.strokeRect @selection.x, @selection.y,
                                    @selection.w, @selection.h
                @selection.drawSelectionHandles()
        @

    getMouse: (e) ->
        element = @canvas[0]
        offsetX = @stylePaddingLeft + @styleBorderLeft + @htmlLeft
        offsetY = @stylePaddingTop + @styleBorderTop + @htmlTop

        while element.offsetParent?
            offsetX += element.offsetLeft
            offsetY += element.offsetTop
            element = element.offsetParent

        x: e.pageX-offsetX, y: e.pageY-offsetY
