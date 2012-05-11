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

  @javascript
  Scenario: Choices already exist
    Given there are 2 ballots for a poll
    And the 1st voter voted for "Broccoli, Zucchini, Brussel sprouts"
    And I am the 2nd voter
    When I am on my ballot page
    And I drag "Broccoli" to my #1 slot
    And I drag "Zucchini" to my #2 slot
    And I drag "Brussel sprouts" to my #3 slot
    And I press "Cast your vote"
    And "Broccoli" should be the 1st borda result
    And "Zucchini" should be the 2nd borda result
    And "Brussel sprouts" should be the 3rd borda result
    When I follow "Return to My Ballot"
    Then I should see "Broccoli" within my ballot
    And I should see "Zucchini" within my ballot
    And I should see "Brussel sprouts" within my ballot
