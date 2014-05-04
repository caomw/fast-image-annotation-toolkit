class ImageManager
    constructor: (@_addImage, @_setFilename) ->
        @currentImage = null

    getNextImage: =>
        try
            # pop index 0
            @currentImage = @files.splice(0, 1)[0]
            img = new Image
            img.src = URL.createObjectURL @currentImage
            img.onload = =>
                @_addImage img
                @_setFilename @currentImage.name

    addImages: (files) =>
        if not @files?
            @files = []

        for file in files
            @files.push file

        @getNextImage()

    getCount: () ->
        @files.length
    
    getFilename: ->
