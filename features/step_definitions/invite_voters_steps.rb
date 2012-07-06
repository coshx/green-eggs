Given /^I have created a poll$/ do
  @poll = FactoryGirl.create(:poll)
end

Then /^"([^"]*)" should receive an email with a ballot link, poll description, and the invitation message$/ do |email|
  msg = unread_emails_for(email).last
  open_email(email)
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
  page.find_field("group_invitation_link").value.should match(@poll.id)
end

When /^I follow the group invitation link$/ do
  @link = page.find_field("group_invitation_link").value
  visit @link
end

When /^I follow the shortened group invitation link$/ do
  @short_link = page.find_field("shortened_group_invitation_link").value
  visit @short_link
end


Then /^I should see that the invitation link is disabled$/ do
  wait_until { @poll.reload.invitation_key.blank? }
  page.find_field("group_invitation_link").value.should match("disabled")
end

When /^go to the old group invitation link$/ do
  visit @link
end

When /^go to the old shortened group invitation link$/ do
  visit @short_link
end
