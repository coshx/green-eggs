GreenEggs.choicesController = Ember.ArrayController.create(
  content: []

  addChoice: ->
    return false unless $("div#choices").attr("data-allow-user-choices") == "true"
    @pushObject GreenEggs.Choice.create()
)
