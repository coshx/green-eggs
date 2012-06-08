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
    inList = 0
    toRemove = 0
    @$().sortable(
      # http://forum.jquery.com/topic/drag-item-out-of-a-sortable
      beforeStop: (event, ui) ->
        # need to figure out if we're going to remove slot before sorting is done
        if inList == 1
          self.calculatePriorities()
        else
          # can't actually remove slot until sorting is done
          toRemove = 1
      stop: (event, ui) ->
        if toRemove = 1
          slotView = ui.item
          slot = Ember.View.views[ui.item.attr("id")].get("bindingContext")
          slotView.remove()
          GreenEggs.choicesController.pushObject(slot.choice)
          GreenEggs.slotsController.removeSlot(slot)
          toRemove = 0
      out: (event, ui) ->
        inList = 0
      over: (event, ui) ->
        inList = 1
      receive: (event, ui) ->
        inList = 1
    )

  calculatePriorities: ->
    itemsOrdered = @$("li")
    (->
      # this sucks
      view.content.set("priority", $.inArray(view._childViews[0].$()[0], itemsOrdered))
    )() for view in @get("childViews")
)
