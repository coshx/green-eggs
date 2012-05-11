Feature: Vote on poll
  As an invited voter
  I want to vote on the poll
  So I may express my preferences

  @javascript
  Scenario: Vote for a single choice
    Given I have a ballot for a poll
    And I am on my ballot page
    And I create the choice "tuna fish"
    And I drag the choice to my #1 slot
    And I press "Cast your vote"
    Then I should see "Results"
    And I should see "tuna fish"

  @javascript
  Scenario: Several ballots with several choices
    Given there are 3 ballots for a poll
    And the 1st voter votes for "Dog, Cat, Goldfish"
    And the 2nd voter votes for "Dog, Cow, Pickle"
    And the 3rd voter votes for "Antelope, Gravy, Horserace"
    Then "Dog" should be the only IRV result
    And "Dog" should be the 1st borda result
    And "Antelope" should be the 2nd borda result
