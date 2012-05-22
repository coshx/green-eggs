GreenEggs.choicesController = Ember.ArrayController.create(
  content: []

  loadAll: (choices) ->
    @set "content", choices

  addChoice: ->
    @pushObject GreenEggs.Choice.create()

  contentDidChange: (->
    @_super()
    # TODO count choice objects rather than choice elements
    if $("div#choices").attr("data-allow-user-choices") == "true" and $("#choices input:text[value='']").length == 0
      @addChoice()
  ).observes('content')
)
