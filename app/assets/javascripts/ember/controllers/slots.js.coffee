GreenEggs.slotsController = Ember.ArrayController.create(
  content: []

  loadAll: (choices) ->
    @set "content", choices.map((choice) ->
      GreenEggs.Slot.create(choice: GreenEggs.Choice.create(choice))
    )

  addSlot: ->
    @pushObject GreenEggs.Slot.create()

  contentDidChange: (->
    @_super()
    @maybeAddSlot()
  ).observes('content')

  maybeAddSlot: ->
    loop
      emptySlots = (slot for slot in @content when !slot.choice)
      break if (@content.length > 2 and emptySlots.length > 0)
      @addSlot()

  vote: ->
    # mapping and sorting in coffeescript sucks
    choices = ({original: slot.choice.original, priority: slot.priority} for slot in @get("content") when slot.choice)
    choices.sort((x,y)->
      (x.priority > y.priority) ? -1 : 1
    )
    choices = (choice.original for choice in choices)
    postData = {}
    postData.choices = choices
    postData.ballot_key = @ballotKey
    postData.poll_id = @pollId
    $.ajax(
      url: "/ballots/update"
      type: "POST"
      data: postData
      dataType: "script"
    )
    false

)
