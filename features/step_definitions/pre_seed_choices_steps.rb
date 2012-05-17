When /^I add the choice "([^"]*)"$/ do |choice|
 num = all("li").count
 fill_in("poll_choices_attributes_#{num-1}_original", :with => choice)
 # simulate the voter pressing the "Enter" key
 script = "e = jQuery.Event('keypress'); e.keyCode = 13; $('input#poll_choices_attributes_#{num-1}_original').trigger(e);"
 page.execute_script(script)
end

When /^I have a ballot for the poll$/ do
  @poll = Poll.last
  @ballot = @poll.ballots.create
end
