GreenEggs.ShowSlotView = Ember.View.extend(
  templateName: "ember/templates/slots/show"
  classNames: ["slot"]
  tagName: "li"

  didInsertElement: ->
    @_super()
    @get("parentView").sort()
)
