#_require ./shape.coffee
#
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
