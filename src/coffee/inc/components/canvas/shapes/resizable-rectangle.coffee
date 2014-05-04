#_require ./rectangle.coffee

class ResizableRectangle extends Rectangle
    constructor: (@canvas, @x, @y, @w, @h, @color = '#AAA') ->
        @selectionHandles = []
        for i in [0..7]
            @selectionHandles.push (new SelectionHandle @canvas, i)

    draw: (canvas = @canvas) ->
        if not @isOutsideCanvas canvas
            canvas.context.lineWidth = 2
            canvas.context.strokeStyle = @color
            canvas.context.strokeRect @x, @y, @w, @h

            if @label?
                canvas.context.fillStyle = "black"
                canvas.context.font = "11px Arial"
                canvas.context.strokeStyle = "white"
                canvas.context.lineWidth = 3
                canvas.context.strokeText @label, @x+3, @y+14
                canvas.context.fillText @label, @x+3, @y+14

    drawSelectionHandles: (canvas = @canvas) ->
        for handle in @selectionHandles
            [x, y] = switch handle.getResizeDirection()
                when 'top-left'      then [@x        ,@y       ]
                when 'top-middle'    then [@x + @w/2 ,@y       ]
                when 'top-right'     then [@x + @w   ,@y       ]
                when 'middle-left'   then [@x        ,@y + @h/2]
                when 'middle-right'  then [@x + @w   ,@y + @h/2]
                when 'bottom-left'   then [@x        ,@y + @h  ]
                when 'bottom-middle' then [@x + @w/2 ,@y + @h  ]
                when 'bottom-right'  then [@x + @w   ,@y + @h  ]

            handle.setCenter x, y
            handle.draw canvas

    resize: (direction, x, y, w, h, dx, dy) ->
        [dx, dy, dw, dh] = switch direction
            when 'top-left'      then [dx ,dy ,-dx ,-dy]
            when 'top-middle'    then [0  ,dy ,0   ,-dy]
            when 'top-right'     then [0  ,dy ,dx  ,-dy]
            when 'middle-left'   then [dx ,0  ,-dx ,0  ]
            when 'middle-right'  then [0  ,0  ,dx  ,0  ]
            when 'bottom-left'   then [dx ,0  ,-dx ,dy ]
            when 'bottom-middle' then [0  ,0  ,0   ,dy ]
            when 'bottom-right'  then [0  ,0  ,dx  ,dy ]

        if w + dw < 0
            dx = if dx > 0 then w else w + dw
            dw = -2*w - dw
        if h + dh < 0
            dy = if dy > 0 then h else h + dh
            dh = -2*h - dh

        [@x, @y, @w, @h] = [x+dx, y+dy, w+dw, h+dh]
