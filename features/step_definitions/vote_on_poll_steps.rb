Given /^I have a ballot for a poll$/ do
  @poll = FactoryGirl.create(:poll)
  @ballot = @poll.ballots.create
end

Given /^there are (\d+) ballots for a poll$/ do |num|
  @poll = FactoryGirl.create(:poll)
  num.to_i.times do
    @poll.ballots.create
  end
end

Given /^I fill in my (\d+)(?:rd|st|nd|th) choice with "([^"]*)"$/ do |ord, value|
  fill_in("ballot_choices_attributes_#{ord.to_i-1}_original", :with => value)
end

Given /^the (\d+)(?:rd|st|nd|th) voter votes for "([^"]*)"$/ do |ord, choices|
  @ballot = @poll.ballots[ord.to_i-1]
  visit vote_on_ballot_path(:poll_id => @ballot.poll.id, :ballot_key => @ballot.key)
  choices.split(", ").each_with_index do |choice, index|
    fill_in("ballot_choices_attributes_#{index}_original", :with => choice)
    # simulate the voter pressing the "Enter" key
    script = "e = jQuery.Event('keypress'); e.keyCode = 13; $('input#ballot_choices_attributes_#{index}_original').trigger(e);"
    page.execute_script(script)
  end
  step %{I press "Cast your vote"}
end

Then /^"([^"]*)" should be the only IRV result$/ do |choice|
  choices = all("div#irv-results table tbody th")
  choices.count.should == 1
  choices[0].text.should == choice
end

Then /^"([^"]*)" should be the (\d+)(?:rd|st|nd|th) borda result$/ do |choice, num|
  choices = all("div#borda-results table tbody th")
  choices[num.to_i-1].text.should == choice
end
