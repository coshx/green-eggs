Feature: Group Invitation
  As a poll creator
  I want to invite an entire group of people quickly
  So that I can run a large poll with ease

  @javascript
  Scenario: Poll admin enables group link then disables it
    Given I have created a poll
    And I am on the poll admin page
    And I follow "Invite voters"
    And I check "group_invitation"
    Then I should see the group invitation link
    When I follow the group invitation link
    Then I should see "What to order for Friday lunch?"
    When I am on the invite voters page
    And I follow the shortened group invitation link
    Then I should see "What to order for Friday lunch?"

    When I am on the invite voters page
    And I uncheck "group_invitation" and confirm the dialog
    Then I should see that the invitation link is disabled
    When go to the old group invitation link
    Then I should see "The page you were looking for doesn't exist."
    And I should not see "What to order for Friday lunch?"
    When go to the old shortened group invitation link
