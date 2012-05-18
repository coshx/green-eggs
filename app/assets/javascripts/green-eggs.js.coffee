window.GreenEggs ||=  {}

jQuery(document).ready ->
  GreenEggs.addChoice = ->
    return false unless $("div#choices").attr("data-allow-user-choices") == "true"
    choice = jQuery("<li class='choice'><input type='text'></li>")
    choice.appendTo "ul#choices"
    GreenEggs.setDraggable(choice)
    jQuery("ul#choices input[type='text']").last().focus()

  GreenEggs.addSlot = ->
    newSlot = $("<li class='slot inactive empty'>-empty-</li>")
    newSlot.appendTo("ol#slots")
    GreenEggs.setSlotDroppable(newSlot)

  jQuery("ol.sortable").sortable()

  GreenEggs.setDraggable = (selector) ->
    $(selector).draggable revert: ( event, ui ) ->
      $(this).data("draggable").originalPosition =
        top: 0
        left: 0

      not event

  GreenEggs.setDraggable("div#choices li")

  GreenEggs.setSlotDroppable("div#ballot li.slot")

  GreenEggs.setDraggable("ol#slots li")
  $("div#container").droppable (
    accept: "li.slot:not(.empty)",
    drop: (event, ui) ->
      return false if !$(ui.draggable).hasClass("ui-draggable")
      choicesList = $("ul#choices")
      choice = $(ui.draggable)
      choice.removeClass("slot")
      choice.attr("style", "")
      choice.droppable("disable")
      choice.addClass("choice")
      choice.appendTo(choicesList)
      GreenEggs.setDraggable(choice)
      if $("ol.slots").length < 3
        GreenEggs.addSlot()
  )

  jQuery("ul#choices input[type='text']").live "keypress", (e) ->
    if this is jQuery("ul#choices input[type='text']").last()[0] and e.keyCode is 13
      GreenEggs.addChoice()
      false

  $(document).on "keyup", "li input[type='text']", (e) ->
    $(this).attr("value", $(this).val())

  jQuery("input[value='Cast your vote']").bind "click", ->
    GreenEggs.prepareBallotForm()
    $("form.ballot").submit()

  GreenEggs.addChoice()

GreenEggs.setSlotDroppable = (selector) ->
  $(selector).droppable (
    accept: (event, ui) ->
      $(this).hasClass("empty")
    drop: (event, ui) ->
      return false if !$(ui.draggable).hasClass("ui-draggable")
      slot = $(this)
      choice = $(ui.draggable)
      slot.html(choice.html())
      if choice.find("input").length > 0
         slot.attr("data-choice-original", choice.find("input").val())
         slot.find("input").val(choice.find("input").val())
      else
         slot.attr("data-choice-original", choice.attr("data-choice-original"))
      choice.remove()
      slot.removeClass("empty")
      GreenEggs.setDraggable(slot)
      if $("ol#slots li.empty").length == 0
        GreenEggs.addSlot()
      if $("#choices input:text[value='']").length == 0
        GreenEggs.addChoice()
      false
  )

GreenEggs.prepareBallotForm = ->
  $.each($("ol#slots li:not(.empty)"), (index, slot) ->
    $(slot).append("<input class='choice' type='hidden'>") if $(slot).find("input.choice").length == 0
    choice = $(slot).find("input.choice")
    choice.attr("name", "ballot[choices_attributes][#{index}][original]")
    choice.attr("value", $(slot).attr("data-choice-original"))
    $(slot).append("<input class='priority' type='hidden'>") if $(slot).find("input.priority").length == 0
    priority = $(slot).find("input.priority")
    priority.attr("name", "ballot[choices_attributes][#{index}][priority]")
    priority.attr("value", index)
  )
