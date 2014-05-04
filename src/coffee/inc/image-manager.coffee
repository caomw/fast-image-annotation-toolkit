class ImageManager
    constructor: (@_addImage) ->

    getNextImage: =>
        try
            # pop index 0
            nextFile = @files.splice(0, 1)[0]
            img = new Image
            img.src = URL.createObjectURL nextFile
            img.onload = =>
                @_addImage img

    addImages: (files) =>
        if not @files?
            @files = []

        for file in files
            @files.push file

        @getNextImage()

    getCount: () ->
        @files.length
