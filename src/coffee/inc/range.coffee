#_require ./helpers.coffee

class RangesSlider
    constructor: (@rangeInput, @callback) ->
        # @rangeInput here is a jQuery object

        @isDragging = false
        @initializeEvents()
        @setValue 0

    initializeEvents: ->
        @rangeInput.mousedown (e) =>
            @isDragging = true

        @rangeInput.mouseup (e) =>
            @isDragging = false
            @setValue @getValue

        @rangeInput.mousemove (e) =>
            @isDragging = true
            if @isDragging
                @setValue @rangeInput[0].value
                @callback @getValue()

    setValue: (value) ->
        @value = value
        @rangeInput[0].value = value

    getValue: ->
        parseInt @value
