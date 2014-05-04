#_require ./components/labels.coffee

createAnnotation = ->
    if Window.canvas?
        canvas = Window.canvas
        if not canvas.isResizing
            shape = canvas.addShape()
            canvas.startResizingShape shape, 'top-left', canvas.mx, canvas.my
        else
            canvas.stopMovingAndResizing()
            canvas.unselectShape()
        canvas.refresh()

$(document).on 'keydown', null, 'c', (e) ->
    createAnnotation()


$(document).on 'keydown', null, 'd', (e) ->
    if Window.canvas?
        canvas = Window.canvas
        canvas.removeShape canvas.selection if canvas.selection
        canvas.refresh()

$(document).on 'keydown', null, 'esc', (e) ->
    e.preventDefault()
    if Window.canvas?
        canvas = Window.canvas
        canvas.unselectShape()
        canvas.stopMovingAndResizing()
        canvas.refresh()

$(document).on 'keydown', null, '1 2 3 4 5 6 7 8 9', (e) ->
    e.preventDefault()
    if Window.labels?
        index = e.keyCode - 49
        label = Window.labels.getLabel index
        console.log "label selected: " + label
        Window.canvas.setCurrentLabel label

        createAnnotation()
