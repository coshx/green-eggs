GreenEggs.choicesController = Ember.ArrayController.create(
  content: []

  loadAll: (choices) ->
    @set "content", choices.map((choice) ->
      GreenEggs.Choice.create(choice))

  addChoice: ->
    @pushObject GreenEggs.Choice.create()

  removeChoice: (choice) ->
    @removeAt(@content.indexOf(choice))
    @maybeAddChoice()

  contentDidChange: (->
    @_super()
    @maybeAddChoice()
  ).observes('content')

  maybeAddChoice: ->
    # TODO count choice objects rather than choice elements
    if $("div#choices").attr("data-allow-user-choices") == "true" and $(".choices input:text[value='']").length == 0
      @addChoice()
)
