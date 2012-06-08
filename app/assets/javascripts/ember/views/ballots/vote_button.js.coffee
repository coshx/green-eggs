GreenEggs.VoteButtonView = Ember.View.extend(
  templateName: "ember/templates/ballots/vote_button"
  tagName: "button"
  attributeBindings: ['disabled']
  disabled: false

  click: ->
    @set("disabled", true)
    GreenEggs.slotsController.vote()
)
