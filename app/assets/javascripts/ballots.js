jQuery(document).ready(function(){
	jQuery("a#add_choice").bind("click",function(){
<<<<<<< HEAD
		jQuery('<li><input type="text" name="choice_1" id="choice_1"></li>').appendTo("ol#choices");
		jQuery("#choice_1").sortable({
			revert: true
 		});
	
		jQuery("li").disableSelection();
=======
    var num = jQuery('form li.string.optional').size();
    jQuery('<li id="ballot_choices_attributes_'+num+'original_input" class="string optional"><label for="ballot_choices_attributes_'+num+'_original">Original</label><input type="text" name="ballot[choices_attributes]['+num+'][original]" id="ballot_choices_attributes_'+num+'_original"></li>').appendTo("form.formtastic.ballot div.fields > ol");
	    });
>>>>>>> 7db4f699a0618e5124f8deae5c2332f818792a48

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
<<<<<<< HEAD

	jQuery("input#choice_1").draggable();
=======
>>>>>>> 7db4f699a0618e5124f8deae5c2332f818792a48
    });
