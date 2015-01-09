Feature: Howitzer CLI Help

  Scenario Outline: Run with help global option
    When I run `howitzer <option>`
    Then the output should contain exactly:
    """
    NAME
        howitzer - Ruby based framework for acceptance testing

    SYNOPSIS
        howitzer [global options] command [command options] [arguments...]

    VERSION
        <HOWITZER_VERSION>

    GLOBAL OPTIONS
        --help    - Show this message
        --version - Display the program version

    COMMANDS
        help   - Shows a list of commands or help for one command
        new    - Generate new project
        update - Upgrade existing project

    """
    And the exit status should be 0
  Examples:
    | option |
    |        |
    | --help |
    | -h     |