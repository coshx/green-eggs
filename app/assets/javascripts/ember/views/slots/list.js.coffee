GreenEggs.ListSlotsView = Ember.View.extend(
  templateName: "ember/templates/slots/list"
  slotsBinding: "GreenEggs.slotsController"
  tagName: "ol"

  refreshListing = ->
    GreenEggs.slotsController.get "content"

  didInsertElement: ->
    @_super()

  sort: ->
    @$().sortable()

)
