GreenEggs.ListSlotsView = Ember.View.extend(
  templateName: "ember/templates/slots/list"
  slotsBinding: "GreenEggs.slotsController"

  refreshListing = ->
    GreenEggs.slotsController.get "content"
)
