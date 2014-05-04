Array::remove = (e) ->
    @[t..t] = [] if (t = @indexOf(e)) > -1

# Always return an integer CSS value
$.fn.cssNumber = (property) ->
    value = parseInt @css(property), 10
    if isNaN value then 0 else value
