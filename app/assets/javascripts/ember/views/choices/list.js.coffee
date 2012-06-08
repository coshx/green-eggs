GreenEggs.ListChoicesView = Ember.View.extend(
  templateName: "ember/templates/choices/list"
  choicesBinding: "GreenEggs.choicesController"
  classNames: ["choices"]
  tagName: "ul"

  refreshListing = ->
    GreenEggs.choicesController.get "content"
)
