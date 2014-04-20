#_require ../shapes/shape.coffee

class SelectionHandle extends Rectangle
    constructor: (@canvas, @position, @x=0, @y=0, @w=7, @h=7,
                  @color='darkred') ->
        @cursorTypes =
            'top-left': 'nw-resize'
            'top-middle': 'n-resize'
            'top-right': 'ne-resize'
            'middle-left': 'w-resize'
            'middle-right': 'e-resize'
            'bottom-left': 'sw-resize'
            'bottom-middle': 's-resize'
            'bottom-right': 'se-resize'

    # 0 1 2
    # 3   4
    # 5 6 7
    getResizeDirection: ->
        switch @position
            when 0 then 'top-left'
            when 1 then 'top-middle'
            when 2 then 'top-right'
            when 3 then 'middle-left'
            when 4 then 'middle-right'
            when 5 then 'bottom-left'
            when 6 then 'bottom-middle'
            when 7 then 'bottom-right'

    getCursor: ->
        @cursorTypes[@getResizeDirection()]
