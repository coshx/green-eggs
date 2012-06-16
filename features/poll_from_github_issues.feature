Feature: create poll from github issues
  As a github project maintainer
  I want to be able to create a poll from my open issues
  So I can find which issues are most important to the community

  @github_issues
  @javascript
  Scenario: Create poll from github issues, public repo
    Given I am on the new poll from gh issues page
    And I enter "wolfie@example.com" for "poll_owner_email"
    And I enter "https://github.com/coshx/green-eggs" for "repository_url"
    And I press "Save"
    When I follow "Pre-seed choices"
    Then I should see a field "add description to polls"
    And I should see a field "admin should not be able to see links to all ballots"
    And I should see a field "admin can remind voters by email"
    And the "Allow users to create their own choices" checkbox should not be checked
    When I have a ballot for the poll
    And I am on my ballot page
    Then there should be a choice "add description to polls" within the choices column
    Then there should be a choice "admin should not be able to see links to all ballots" within the choices column
    Then there should be a choice "admin can remind voters by email" within the choices column
