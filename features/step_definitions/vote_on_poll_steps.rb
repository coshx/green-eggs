def find_choice(value)
  choices = all("li").select {|c| (c.all("input").present? && c.find("input").value == value) || c.text.match(value)}
  choices.first
end

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

Given /^I create the choice "([^"]*)"$/ do |value|
  all("ul.choices li").last.find("input").set(value)
  step %{there should be a choice "#{value}" within the choices column}
end

Given /^there should be a choice "([^"]*)"$/ do |value|
  find_choice(value).should be_present
end

Then /^there should not be a choice "([^"]*)"$/ do |value|
  find_choice(value).should_not be_present
end

When /^I drag "([^"]*)" from my ballot to the choices column$/ do |value|
  choice = find_choice(value)
  choice.drag_to(page.find("ul.choices"))
end

Given /^I drag the choice to my \#(\d+) slot$/ do |num|
  all("ul.choices li").last.drag_to(find(:xpath, "//ol[contains(@class, 'slots')]//li[#{num}]"))
end

Given /^I drag "([^"]*)" to my \#(\d+) slot$/ do |choice, num|
  find_choice(choice).drag_to(find(:xpath, "//ol[contains(@class, 'slots')]//li[#{num}]"))
end

Given /^the (\d+)(?:rd|st|nd|th) voter votes for "([^"]*)"$/ do |ord, choices|
  @ballot = @poll.ballots[ord.to_i-1]
  visit vote_on_ballot_path(:poll_id => @ballot.poll.id, :ballot_key => @ballot.key)
  choices.split(", ").each_with_index do |choice, index|
    step %{I create the choice "#{choice}"}
    step %{I drag the choice to my ##{index+1} slot}
  end
  step %{I cast my vote}
end

Given /^the (\d+)(?:rd|st|nd|th) voter voted for "([^"]*)"$/ do |ord, choices|
  @ballot = @poll.ballots[ord.to_i-1]
  choices.split(", ").each_with_index do |choice, index|
    @ballot.choices << Choice.new(:original => choice, :priority => index)
  end
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

Given /^I am the (\d+)(?:rd|st|nd|th) voter$/ do |ord|
  @ballot = @poll.ballots[ord.to_i-1]
end

Then /^there should be only a blank choice$/ do
  choices = all(:xpath, "//ul[contains(@class, 'choices')]/li")
  choices.count.should == 1
  choice = choices.first
  choice.find("input").value.should == ""
end

Then /^there should be (\d+) empty slot(?:s|)$/ do |num|
  slots = all(:xpath, "//ol[contains(@class, 'slots')]//li[contains(., 'empty')]")
  slots.count.should == num.to_i
end

Then /^there should be (\d+) non\-empty slot(?:s|)$/ do |num|
  slots = all(:xpath, "//ol[contains(@class, 'slots')]//li[not(contains(., 'empty'))]")
  slots.count.should == num.to_i
end

When /^I cast my vote$/ do
  step %{I press "Cast your vote"}
  wait_until { URI.parse(current_url).path == path_to("the poll results") } 
end
