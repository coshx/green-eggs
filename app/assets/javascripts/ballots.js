jQuery(document).ready(function(){
	jQuery("a#add_choice").bind("click",function(){
		jQuery('<li><input type="text" name="choice_1" id="choice_1"></li>').appendTo("ol#choices");
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