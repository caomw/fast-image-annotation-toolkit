#_require ./shape.coffee
#
class ResizableRectangle extends Shape
    constructor: (@canvas, @x, @y, @w, @h, @color = '#AAA') ->
        @selectionHandles = []
        for i in [0..7]
            @selectionHandles.push (new Rectangle @canvas)

    draw: (canvas = @canvas) ->
        if not @isOutsideCanvas canvas
            canvas.context.lineWidth = 2
            canvas.context.strokeStyle = @color
            canvas.context.strokeRect @x, @y, @w, @h


    drawSelectionHandles: (canvas = @canvas) ->
        for handle, i in @selectionHandles
            [x, y] =
                [[@x, @y], [@x + @w/2, @y], [@x + @w, @y], [@x, @y + @h/2],
                    [@x + @w, @y + @h/2], [@x, @y + @h], [@x + @w/2, @y + @h],
                    [@x + @w, @y + @h]][i]
            handle.setCenter x, y
            handle.draw canvas

    resize: (direction, x, y, w, h, dx, dy) ->
        [dx, dy, dw, dh] = switch direction
            when 0 then [dx, dy, -dx, -dy]
            when 1 then [0,  dy, 0,   -dy]
            when 2 then [0,  dy, dx,  -dy]
            when 3 then [dx, 0,  -dx, 0]
            when 4 then [0,  0,  dx,  0]
            when 5 then [dx, 0,  -dx, dy]
            when 6 then [0,  0,  0,   dy]
            else        [0,  0,  dx,  dy]

        if w + dw < 0
            dx = if dx > 0 then w else w + dw
            dw = -2*w - dw
        if h + dh < 0
            dy = if dy > 0 then h else h + dh
            dh = -2*h - dh

        [@x, @y, @w, @h] = [x+dx, y+dy, w+dw, h+dh]
