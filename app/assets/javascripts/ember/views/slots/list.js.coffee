GreenEggs.ListSlotsView = Ember.View.extend(
  templateName: "ember/templates/slots/list"
  slotsBinding: "GreenEggs.slotsController"
  tagName: "ol"
  classNames: ["slots"]

  refreshListing = ->
    GreenEggs.slotsController.get "content"

  didInsertElement: ->
    @_super()

  setSortable: ->
    self = @
    @$().sortable(
      stop: (event, ui) ->
        self.calculatePriorities()
    )

  calculatePriorities: ->
    itemsOrdered = @$("li")
    (->
      # this sucks
      view.content.set("priority", $.inArray(view._childViews[0].$()[0], itemsOrdered))
    )() for view in @get("childViews")
)
