jQuery(document).ready(function(){
	jQuery("a#add_choice").bind("click",function(){
    var num = jQuery('form li.string.optional').size();
    jQuery('<li id="ballot_choices_attributes_'+num+'original_input" class="string optional"><label for="ballot_choices_attributes_'+num+'_original">Original</label><input type="text" name="ballot[choices_attributes]['+num+'][original]" id="ballot_choices_attributes_'+num+'_original"></li>').appendTo("form.formtastic.ballot div.fields > ol");
	    });

	jQuery("input[value='Vote']").bind("click",function(){
		var choicesArray = "";
		jQuery("ol#choices input").each(function(i,element){
			choicesArray += element.value;
			choicesArray += ",";
		});
		
		choicesArray = choicesArray.slice(0,-1);
		jQuery("input#choices_array").val(choicesArray);
	    });
    });
