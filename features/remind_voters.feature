Feature: Poll creator reminds voters
  As a poll creator
  I want send my voters a friendly reminder
  So they vote

  Scenario: User creates poll
    Given I have created a poll
    And I am on the poll admin page
    And I follow "Invite voters"
    And I enter "vino@example.com" for "emails"
    And I press "Send invites"
    Then I should see "Successfully invited vino@example.com"
    And "vino@example.com" should receive an email with a ballot link, poll description, and the invitation message
    When I follow "Remind voters by email"
    Then I should see "Successfully sent reminder email(s)"
    And "vino@example.com" should receive an email with a ballot link, poll description, and the invitation message
