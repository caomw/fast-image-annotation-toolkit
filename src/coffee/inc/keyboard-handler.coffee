$(document).on 'keydown', null, 'c', (e) ->
    if Window.canvas?
        canvas = Window.canvas
        if not canvas.isResizing
            shape = canvas.addShape()
            canvas.startResizingShape shape, 0, canvas.mx, canvas.my
        else
            canvas.stopMovingAndResizing()
            canvas.unselectShape()
        canvas.refresh()

$(document).on 'keydown', null, 'esc d', (e) ->
    if Window.canvas?
        canvas = Window.canvas
        canvas.removeShape canvas.selection if canvas.selection
        canvas.refresh()
