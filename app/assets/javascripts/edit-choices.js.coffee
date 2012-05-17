window.GreenEggs ||= {}

$(document).ready ->
  $("ul#poll-choices input[type='text']").live "keypress", (e) ->
    if this is jQuery("ul#poll-choices input[type='text']").last()[0] and e.keyCode is 13
      num = jQuery('form ul li').size()
      $('<li id="poll_choices_attributes_'+num+'_original_input" class="string optional"><input type="text" name="poll[choices_attributes]['+num+'][original]" id="poll_choices_attributes_'+num+'_original"></li>').appendTo("form.formtastic.poll div.fields ul")
      $("div.fields ul input[type='text']").last().focus()
      false
