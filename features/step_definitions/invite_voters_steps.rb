Given /^I have created a poll$/ do
  @poll = FactoryGirl.create(:poll)
end

Then /^"([^"]*)" should receive an email with a ballot link, poll description, and the invitation message$/ do |email|
  unread_emails_for(email).size.should == 1
  msg = open_email(email)
  ballot = @poll.reload.ballots.last
  ballot_link = "http://#{ActionMailer::Base.default_url_options[:host]}/#{@poll.id}/#{ballot.key}"
  description = @poll.reload.description
  invitationMessage = ballot.reload.invitationMessage
  msg.body.should include(ballot_link, description, invitationMessage)
end

Then /^I follow the ballot link$/ do
  click_first_link_in_email
end

Then /^I should see the group invitation link$/ do
  wait_until { @poll.reload.invitation_key.present? }
  page.find_field("group_invitation_link").value.should match(@poll.invitation_key)
end

When /^I follow the group invitation link$/ do
  link = page.find_field("group_invitation_link").value
  visit link
end
