jQuery(document).ready(function(){
	jQuery("a#add_choice").bind("click",function(){
    var num = jQuery('form ol li').size();
    jQuery('<li id="ballot_choices_attributes_'+num+'original_input" class="string optional"><label for="ballot_choices_attributes_'+num+'_original">Original</label><input type="text" name="ballot[choices_attributes]['+num+'][original]" id="ballot_choices_attributes_'+num+'_original"></li>').appendTo("form.formtastic.ballot div.fields > ol");
	    });

	jQuery("input[value='Cast your vote']").bind("click",function(){
    // append the priority hidden fields before submitting
    var num = jQuery('form ol li').size();
    for (i = 0; i < num; i++) {
      jQuery("ol li:eq("+i+")").append('<input type="hidden" name="ballot[choices_attributes]['+i+'][priority]" id="ballot_choices_attributes_'+i+'_priority" value="'+i+'">');
    }
  
	});

});
