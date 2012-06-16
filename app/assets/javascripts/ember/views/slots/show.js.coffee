GreenEggs.ShowSlotView = Ember.View.extend(
  templateName: "ember/templates/slots/show"
  classNames: ["slot"]
  tagName: "li"

 didInsertElement: ->
    @_super()
    @get("parentView").setSortable()
    @get("parentView").calculatePriorities()
    @setDroppable() unless @bindingContext.choice

  setDroppable: ->
    self = @
    @$().droppable (
      accept: ".choice"
      drop: (event, ui) ->
        choiceView = ui.draggable
        choice = Ember.View.views[ui.draggable.attr("id")].get("bindingContext")
        GreenEggs.choicesController.removeChoice(choice)
        self.get("bindingContext").set("choice", choice)
        GreenEggs.slotsController.maybeAddSlot()
    )
)
