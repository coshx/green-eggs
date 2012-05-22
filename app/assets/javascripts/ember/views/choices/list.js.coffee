GreenEggs.ListChoicesView = Ember.View.extend(
  templateName: "ember/templates/choices/list"
  choicesBinding: "GreenEggs.choicesController"

  refreshListing = ->
    GreenEggs.choicesController.get "content"
)
