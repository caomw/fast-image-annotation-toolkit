class FileInput
    # @fileInput: jQuery view object
    # @callback: file input will be passed to this function
    constructor: (@fileInput, @callback) ->
        @fileInputControl = @fileInput.find('input[type=file]')
        @initializeEvents()
        @fileInput.find('input.selected-filename').val ''
        @fileInput.find('input.selected-filename').attr 'disabled', 'disabled'

    initializeEvents: ->
        @fileInput.find('.btn').click =>
            @fileInputControl.click()

        @fileInputControl.change (e) =>
            @fileInput.find('input.selected-filename').val @fileInputControl.val()
            img = new Image
            img.src = URL.createObjectURL(e.target.files[0])
            img.onload = =>
                @callback img
