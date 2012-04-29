Given /^I have a ballot for a poll$/ do
  poll = FactoryGirl.create(:poll_with_ballot)
  @ballot = poll.ballots.first
  @ballot.save
end

Given /^I fill in my (\d+)(?:rd|st|nd|th) choice with "([^"]*)"$/ do |ord, value|
  fill_in("ballot_choices_attributes_#{ord.to_i-1}_original", :with => value)
end

