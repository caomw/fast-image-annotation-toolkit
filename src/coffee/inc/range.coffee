#_require ./helpers.coffee

class RangesSlider
    constructor: (@rangeInput, @callback) ->
        # @rangeInput here is a jQuery object

        @isDragging = false

        @rangeInput.mousedown (e) =>
            @isDragging = true

        @rangeInput.mouseup (e) =>
            @isDragging = false

        @rangeInput.mousemove (e) =>
            if @isDragging
                callback @rangeInput[0].value
