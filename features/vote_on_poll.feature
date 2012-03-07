Feature: Vote on poll
  As an invited voter
  I want to vote on the poll
  So I may express my preferences

  @javascript
  Scenario: Vote for a single choice
    Given I have a ballot for a poll
    And I am on my ballot page
    And I fill in my 1st choice with "tuna fish"
    And I press "Cast your vote"
    Then I should see "Results"
    And I should see "tuna fish"
