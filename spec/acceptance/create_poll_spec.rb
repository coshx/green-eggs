require 'spec_helper'

feature %{
  I want to play with polls
} do

  background do
  end

  scenario "Create a new poll and vote for it", :js => true do
    visit "/create"
    fill_in "question", :with => 'The best way to seduce a rabbit?'
    fill_in "email", :with => "rabbit@stewieland.com"
    page.execute_script("$('#go_to_preseed').click()")
    page.should have_content('The best way to seduce a rabbit?')
    page.should have_content('Pre-seed answers')
    fill_in "answer", :with => "show a huge carrot"
    click_button "add-choice"
    fill_in "answer", :with => "show a huge rabbit of opposite sex"
    click_button "add-choice"
    fill_in "answer", :with => "show a gun"
    click_button "add-choice"
    page.execute_script("$('#save-poll').click()")
    page.driver.browser.switch_to.alert.accept
    page.should have_content('Poll details')
    page.should have_content('The best way to seduce a rabbit?')
    page.execute_script("$('.option').click()")
    click_link "Unchoose"
    click_link "Unchoose"
    page.execute_script("$('#save-poll').click()")
    page.should have_content('show a gun 100%')
  end
  scenario "Should not be able to add choices if switch allow_choices is off", :js => true do
    visit "/create"
    fill_in "question", :with => 'The best way to seduce a rabbit?'
    fill_in "email", :with => "rabbit@stewieland.com"
    #page.execute_script("$('.green-switch').click()")
    page.execute_script("$('#go_to_preseed').click()")
    fill_in "answer", :with => "show a huge carrot"
    click_button "add-choice"
    page.execute_script("$('#save-poll').click()")
    page.driver.browser.switch_to.alert.accept
    #binding.pry
    find('#addOption').should_not be_visible
  end
  scenario "Should be able to add choices if switch allow_choices is on", :js => true do
    visit "/create"
    fill_in "question", :with => 'The best way to seduce a rabbit?'
    fill_in "email", :with => "rabbit@stewieland.com"
    page.execute_script("$('.green-switch').click()")
    page.execute_script("$('#go_to_preseed').click()")
    fill_in "answer", :with => "show a huge carrot"
    click_button "add-choice"
    page.execute_script("$('#save-poll').click()")
    page.driver.browser.switch_to.alert.accept
    find('#addOption').should be_visible
  end

end