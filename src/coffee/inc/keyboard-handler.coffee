$(document).on 'keydown', null, 'c', (e) ->
    if Window.canvas?
        canvas = Window.canvas
        if not canvas.isResizing
            shape = new ResizableRectangle canvas, canvas.mx, canvas.my, 0, 0,
                    'rgba(255, 0, 0, 1)'

            canvas.addShape shape
            canvas.startResizingShape shape, 0, canvas.mx, canvas.my
        else
            canvas.stopMovingAndResizing()
            canvas.unselectShape()
        

$(document).on 'keydown', null, 'esc', (e) ->
