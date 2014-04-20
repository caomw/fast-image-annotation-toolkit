#_require ./shape.coffee

class Rectangle extends Shape
    constructor: (@canvas, @x=0, @y=0, @w=7, @h=7, @color='darkred') ->
