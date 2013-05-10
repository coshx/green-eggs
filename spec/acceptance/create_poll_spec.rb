require 'spec_helper'

feature %{
  I want to play with polls
} do

  background do
  end

  scenario "Create a new poll", :js => true do
    visit "/create"
    fill_in "question", :with => 'The best way to seduce a rabbit?'
    fill_in "email", :with => "rabbit@stewieland.com"
    click_button "go_to_preseed"
    page.should have_content('The best way to seduce a rabbit?')
    page.should have_content('Pre-seed answers')
    fill_in "answer", :with => "show a huge carrot"
    click_button "add-choice"
    fill_in "answer", :with => "show a huge rabbit of opposite sex"
    click_button "add-choice"
    fill_in "answer", :with => "show a gun"
    click_button "add-choice"
    click_button "save-poll"
  end


end