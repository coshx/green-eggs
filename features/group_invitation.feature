Feature: Group Invitation
  As a poll creator
  I want to invite an entire group of people quickly
  So that I can run a large poll with ease

  @javascript
  Scenario: Poll admin uses group link
    Given I have created a poll
    And I am on the poll admin page
    And I follow "Invite voters"
    And I check "group_invitation"
    Then I should see the group invitation link
    When I follow the group invitation link
    Then I should see "Voting on: What to order for Friday lunch?"
