Feature: Howitzer CLI Unknown command

  Scenario: Run with --unknown global option
    When I run `howitzer --unknown`
    Then the output should contain:
    """
    error: Unknown option --unknown
    """
    And the exit status should be 64

  Scenario: Run with unknown command
    When I run `howitzer unknown`
    Then the output should contain:
    """
    error: Unknown command 'unknown'
    """
    And the exit status should be 64