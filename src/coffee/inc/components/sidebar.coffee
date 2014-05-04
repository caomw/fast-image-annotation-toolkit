class SideBar
    # @sideBar: jQuery view object
    constructor: (@sideBar) ->
        @textArea = @sideBar.find '.annotations-meta-info'
        @

    setMetaData: (components) =>
        data = []

        getOrigin = =>
            for component in components
                if component.constructor.name is 'CanvasImage'
                    return component.getCenter()
            return x:0, y:0
        origin = getOrigin()

        for component in components
            data.push switch component.constructor.name
                when 'CanvasImage'
                    type: 'image'
                    centerX: component.centerX
                    centerY: component.centerY
                    w: component.w
                    h: component.h
                    orientation: component.orientation
                when 'ResizableRectangle'
                    type: 'rectangle'
                    x: component.x - origin.x
                    y: component.y - origin.y
                    w: component.w
                    h: component.h
                    label: component.getLabel()

        @textArea.val JSON.stringify data, (key, val) ->
                try
                    if val.toFixed #  set precision of floating point numbers to 4
                        return Number val.toFixed 4
                return val
            , 2 # indentation
