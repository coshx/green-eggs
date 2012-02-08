Given /^I have created a poll$/ do
  @poll = Factory(:poll)
end

Then /^"([^"]*)" should receive an email with a ballot link$/ do |email|
  unread_emails_for(email).size.should == 1
  # TODO test for presence of ballot link!  
end
