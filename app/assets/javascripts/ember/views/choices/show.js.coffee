GreenEggs.ShowChoiceView = Ember.View.extend(
  templateName: "ember/templates/choices/show"
  classNames: ["choice"]
  tagName: "li"

  keyPress: (event, view) ->
    if event.target is $("ul.choices input[type='text']").last()[0] and event.keyCode is 13
      GreenEggs.choicesController.addChoice()
      false
#    @get("bindingContext").set("original", @$("input").val())

  didInsertElement: ->
    @_super()
    @setDraggable()
    @$("input[type='text']").focus()

  setDraggable: ->
    @$().draggable revert: ( event, ui ) ->
      $(this).data("draggable").originalPosition =
        top: 0
        left: 0

      not event

)
