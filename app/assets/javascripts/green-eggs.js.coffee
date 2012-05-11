window.GreenEggs ||=  {}

jQuery(document).ready ->
  GreenEggs.addChoice = ->
    choice = jQuery("<li id=\"ballot_choices_attributes_0_original_input\" class=\"string optional\"><input type=\"text\" name=\"ballot[choices_attributes][0][original]\" id=\"ballot_choices_attributes_0_original\" class='choice'></li>")
    choice.appendTo "ul#choices"
    GreenEggs.setDraggable(choice)
    jQuery("ul#choices input[type='text']").last().focus()

  jQuery("ol.sortable").sortable()
  jQuery("a#add_choice").bind "click", ->
    GreenEggs.addChoice()

  GreenEggs.setDraggable = (selector) ->
    $(selector).draggable revert: ( event, ui ) ->
      $(this).data("draggable").originalPosition =
        top: 0
        left: 0

      not event

  GreenEggs.setDraggable("div#choices li")

  GreenEggs.setDroppable("div#ballot li.slot")

  jQuery("ul#choices input[type='text']").live "keypress", (e) ->
    if this is jQuery("ul#choices input[type='text']").last()[0] and e.keyCode is 13
      GreenEggs.addChoice()
      false

  jQuery("input[value='Cast your vote']").bind "click", ->
    GreenEggs.prepareBallotForm()
    $("form.ballot").submit()

  GreenEggs.addChoice()

GreenEggs.setDroppable = (selector) ->
  $(selector).droppable (
    accept: (event, ui) ->
      $(this).hasClass("empty")
    drop: (event, ui) ->
      return false if !$(ui.draggable).hasClass("ui-draggable")
      slot = $(this)
      choice = $(ui.draggable)
      slot.html(choice.html())
      slot.attr("data-choice-slug", choice.attr("data-choice-slug"))
      slot.attr("data-choice-original", choice.attr("data-choice-original"))
      if choice.find("input")
         slot.find("input").val(choice.find("input").val())
      choice.remove()
      slot.removeClass("empty")
      if $("ol#slots li.empty").length == 0
        newSlot = $("<li class='slot inactive empty'>-empty-</li>")
        newSlot.appendTo("ol#slots")
        GreenEggs.setDroppable(newSlot)
      if $("#choices input:text[value='']").length == 0
        GreenEggs.addChoice()
      false
  )

GreenEggs.prepareBallotForm = ->
  $.each($("ol#slots li:not(.empty)"), (index, slot) ->
    choice = $(slot).find("input.choice")
    choice.attr("id", "ballot_choices_attributes_#{index}_original")
    choice.attr("name", "ballot[choices_attributes][#{index}][original]")
    choice.attr("value", $(slot).attr("data-choice-original")) if $(slot).attr("data-choice-original")
    choice.attr("value", $(choice).attr("data-choice-original")) if $(choice).attr("data-choice-original")
    $(slot).append("<input class='priority' type='hidden'>") if $(slot).find("input.priority").length == 0
    priority = $(slot).find("input.priority")
    priority.attr("name", "ballot[choices_attributes][#{index}][priority]")
    priority.attr("id", "ballot_choices_attributes_#{index}_priority")
    priority.attr("value", index)
  )
