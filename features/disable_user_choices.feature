Feature: Admin disables user choices
  As an admin
  I want to be able disable user choices
  So I find out the group preferences from a particular set of choices

  @javascript
  Scenario: Disable user choices
    Given I have created a poll
    And I am on the poll admin page
    When I follow "Pre-seed choices"
    And I uncheck "Allow users to create their own choices"
    And I press "Save"
    When I have a ballot for the poll
    And am on my ballot page
    Then I should not see a text input within the choices column
    When I am on the poll admin page
    When I follow "Pre-seed choices"
    And I check "Allow users to create their own choices"
    And I press "Save"
    When I am on my ballot page
    Then I should see a text input within the choices column
