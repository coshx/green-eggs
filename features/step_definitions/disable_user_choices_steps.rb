Then /^I should not see a text input$/ do
  page.should_not have_css("input[type='text']")
end

Then /^I should see a text input$/ do
  page.should have_css("input[type='text']")
end
