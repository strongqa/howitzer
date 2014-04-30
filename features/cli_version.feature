Feature: Howitzer CLI Version

  Scenario Outline: Run with version global option
    When I run `howitzer <option>`
    Then the output should contain exactly:
    """
    howitzer version <HOWITZER_VERSION>

    """
    And the exit status should be 0
  Examples:
    | option    |
    | --version |
    | -v        |