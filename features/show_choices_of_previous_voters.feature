Feature: Show choices of previous voters
  As a poll creator
  I want voters to be able to choose the choices of previous voters
  So voters choose some common choices

  @javascript
  Scenario: Voters Sees Choices of Previous Voters
    Given there are 2 ballots for a poll
    And the 1st voter voted for "Tendon, Ligament, Joint"
    And I am the 2nd voter
    When I am on my ballot page
    Then I should see "Tendon" within the choices column
    And I should see "Ligament" within the choices column
    Then I should see "Joint" within the choices column

