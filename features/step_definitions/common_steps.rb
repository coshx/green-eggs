module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

When /^(.*) within (.*[^:])$/ do |step_name, parent|
  with_scope(parent) { step step_name }
end

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )enter "([^"]*)" for "([^"]*)"$/ do |value, field|
  fill_in(field, :with => value)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )check "([^"]*)"$/ do |checkbox|
  check(checkbox)
end

When /^(?:|I )uncheck "([^"]*)"$/ do |checkbox|
  uncheck(checkbox)
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  page.should_not have_content(text)
end

Then /^show me the page$/ do
  save_and_open_page
end

Given /^I wait for (\d+) minutes$/ do |mins|
  sleep(mins.to_i * 60)
end

Then /^I should see a field "([^"]*)"$/ do |value|
  all("input").find {|i| i.value == value}.should be_present
end


Then /^the "([^"]*)" checkbox(?: within (.*))? should be checked$/ do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    field_checked.should be_true
  end
end

Then /^the "([^"]*)" checkbox(?: within (.*))? should not be checked$/ do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    field_checked.should be_false
  end
end
