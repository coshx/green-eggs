Then /^"([^"]*)" should receive an email with an admin link$/ do |email|
  unread_emails_for(email).size.should == 1
  # TODO fix msg body and test for presence of admin link!  
end

