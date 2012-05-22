GreenEggs.ShowChoiceView = Ember.View.extend(
  templateName: "ember/templates/choices/show"
  classNames: ["choice"]
  tagName: "li"

  eventManager: Ember.Object.create(
    keyPress: (event, view) ->
      if event.target is $("ul#choices input[type='text']").last()[0] and event.keyCode is 13
        GreenEggs.choicesController.addChoice()
        false
  )

  didInsertElement: ->
    @_super()
    @$("input[type='text']").focus()

)
