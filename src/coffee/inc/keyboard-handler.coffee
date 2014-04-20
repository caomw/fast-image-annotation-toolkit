$(document).on 'keydown', null, 'c', (e) ->
    if Window.canvas?
        canvas = Window.canvas
        if not canvas.isResizing
            shape = canvas.addShape()
            canvas.startResizingShape shape, 'top-left', canvas.mx, canvas.my
        else
            canvas.stopMovingAndResizing()
            canvas.unselectShape()
        canvas.refresh()

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
