class Labels
    constructor: (@labelInput) ->
        localStorageLabels = localStorage.getItem('labels')
        if localStorageLabels != null
            @labelInput.val localStorageLabels

        if @labelInput.val() == ''
            @labels = ['label1', 'label2', 'label3']
        else
            @parseLabels()

        @initializeEvents()

    initializeEvents: ->
        @labelInput.change =>
            @parseLabels()

    parseLabels: ->
        try
            @labels = @labelInput.val().replace(/^\s*|\s*$/g,'')
                .split(/\s*,\s*/)
            localStorage.setItem('labels', @labels)

    getLabel: (index) ->
        if @labels.length == 0
            return ''
        if index < 0
            return @labels[0]
        if index >= @labels.length
            return @labels[@labels.length-1]
        return @labels[index]
