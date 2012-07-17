Feature: Poll admin invites voters
  As a poll admin
  I want to invite voters
  So they have a chance to express their preferences

  Scenario: Poll admin invites a single voter
    Given I have created a poll
    And I am on the poll admin page
    And I follow "Invite voters"
    And I enter "diamond@example.com" for "emails"
    And I enter "Please vote for casino games!" for "invitationMsg"
    And I press "Send invites"
    Then I should see "Successfully invited diamond@example.com"
    And "diamond@example.com" should receive an email with a ballot link, poll description, and the invitation message
    When I follow the ballot link
    Then I should see "What to order for Friday lunch?"
