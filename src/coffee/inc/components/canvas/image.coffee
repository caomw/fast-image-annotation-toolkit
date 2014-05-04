class CanvasImage
    # resize: resize factor relative to canvas size
    constructor: (@image, @canvas, @orientation=0, resize=0.7) ->
        @centerX = @canvas.width/2
        @centerY = @canvas.height/2

        @resizeRatio = resize *
            Math.max @canvas.width/@image.width, @canvas.height/@image.height

        @w = @image.width * @resizeRatio
        @h = @image.height * @resizeRatio

    #context: canvas context to draw the image
    draw: (context=@canvas.context) =>
        context.save()
        context.translate @centerX, @centerY
        context.rotate @orientation*Math.PI/180
        context.drawImage @image, -@w/2, -@h/2, @w, @h
        context.restore()

    getCenter: =>
        x:@centerX, y:@centerY
