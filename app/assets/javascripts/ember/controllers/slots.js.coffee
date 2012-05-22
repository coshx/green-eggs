GreenEggs.slotsController = Ember.ArrayController.create(
  content: []

  loadAll: (choices) ->
    @set "content", choices.map((choice) ->
      GreenEggs.Slot.create(choice: choice)
    )

  addSlot: ->
    @pushObject GreenEggs.Slot.create()

  contentDidChange: (->
    @_super()
    emptySlots = (slot for slot in @content when !slot.choice)
    @addSlot() if emptySlots.length == 0 or @content.length < 3
  ).observes('content')
)
