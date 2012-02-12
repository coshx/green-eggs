Then /^"([^"]*)" should receive an email with an admin link$/ do |email|
  unread_emails_for(email).size.should == 1
  msg = open_email(email)
  poll = Poll.last
  admin_link = "http://#{ActionMailer::Base.default_url_options[:host]}/#{poll.id}/admin?owner_key=#{poll.owner_key}"
  msg.body.should include(admin_link)
end

Then /^when I follow the admin link$/ do
  click_first_link_in_email
end


