#_require ./shape.coffee

class Rectangle extends Shape
    constructor: (@canvas, @x=0, @y=0, @w=7, @h=7, @color='darkred') ->

    # Return true if the distance between input coordinate and a shape border
    # is less than or equal to dist.
    isOnBorder: (mx, my, dist= 2) ->
        findMinAbs = (list) ->
            Math.min.apply @, (Math.abs x for x in list)

        if @y < my < @y+@h
            return dist >= findMinAbs [mx-@x, mx-@x-@w]
        else if @x < mx < @x+@w
            return dist >= findMinAbs [my-@y, my-@y-@h]

        false
