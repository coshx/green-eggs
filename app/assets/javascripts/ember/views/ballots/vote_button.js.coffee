GreenEggs.VoteButtonView = Ember.View.extend(
  templateName: "ember/templates/ballots/vote_button"
  tagName: "button"
  attributeBindings: ['disabled']
  disabled: false
  content: "Cast your vote"

  click: ->
    @set("disabled", true)
    @set("content", "Please wait...")
    GreenEggs.slotsController.vote()
)
