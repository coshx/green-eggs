Feature: User creates poll
  As a user
  I want to create poll
  So I can find the preferences of my friends

  Scenario: User creates poll
    Given I am on the index page
    And I follow "Create a new poll"
    And I enter "Which games for casino night?" for "poll_name"
    And I enter "dixie@example.com" for "poll_owner_email"
    And I press "Save"
    Then I should see "Poll was successfully created"
    And "dixie@example.com" should receive an email with an admin link
    And when I follow the admin link
    Then I should see "Manage your poll"
