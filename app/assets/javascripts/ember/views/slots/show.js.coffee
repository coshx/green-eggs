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
        oldChoice = Ember.View.views[ui.draggable.attr("id")].get("bindingContext")
        choice = GreenEggs.Choice.create(original: oldChoice.get("original"), slug: oldChoice.get("slug"))
        GreenEggs.choicesController.removeChoice(Ember.View.views[ui.draggable.attr("id")].get("bindingContext"))
        self.get("bindingContext").set("choice", choice)
        GreenEggs.slotsController.maybeAddSlot()
        # TODO make sure this works for existing choices
        #self.rerender()
    )
)
