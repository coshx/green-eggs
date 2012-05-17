Feature: Admin pre-seeds choices
  As an admin
  I want to seed the poll with choices
  So voters don't have to think of their own

  @javascript
  Scenario: Create poll and seed choices
    Given I am on the index page
    And I follow "Create a new poll"
    And I enter "Where should we go for drinks?" for "poll_name"
    And I enter "wolfie@example.com" for "poll_owner_email"
    And I press "Save"
    Then I should see "Poll was successfully created"
    When I follow "Pre-seed choices"
    And I add the choice "Granny smith"
    And I add the choice "Macintosh"
    And I add the choice "Red delicious"
    And I press "Save"
    When I have a ballot for the poll
    And am on my ballot page
    Then I should see "Granny smith" within the choices column
    Then I should see "Macintosh" within the choices column
    Then I should see "Red delicious" within the choices column
