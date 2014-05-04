class Labels
    constructor: (@labelInput) ->
        @labelInput.val('')
        @labels = []
        @initializeEvents()

    initializeEvents: ->
        @labelInput.change =>
            try
                @labels = @labelInput.val().replace(/^\s*|\s*$/g,'').
                    split(/\s*,\s*/)
            catch

    getLabel: (index) ->
        if @labels.length == 0
            return ''
        if index < 0
            return @labels[0]
        if index >= @labels.length
            return @labels[@labels.length-1]
        return @labels[index]
