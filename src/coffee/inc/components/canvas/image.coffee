class CanvasImage
    constructor: (@image, @centerX, @centerY, @w, @h, @orientation) ->
        @

    #context: canvas context to draw the image
    draw: (context) =>
        context.save()
        context.translate @centerX, @centerY
        context.rotate @orientation*Math.PI/180
        context.drawImage @image, -@w/2, -@h/2, @w, @h
        context.restore()

    getCenter: =>
        x:@centerX, y:@centerY
