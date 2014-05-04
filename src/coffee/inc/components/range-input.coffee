class RangesSlider
    # @rangeInput: jQuery view object
    # @callback: value of the slider will be passed to the callback function
    constructor: (@rangeInput, @callback) ->

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
            if @isDragging
                @setValue @rangeInput[0].value
                @callback @getValue()

        @rangeInput.keydown (e) =>
            @setValue @rangeInput[0].value
            @callback @getValue()

    setValue: (value) ->
        @value = value
        @rangeInput[0].value = value

    getValue: ->
        parseInt @value
