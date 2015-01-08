Feature: Howitzer CLI Update Existing Project

  Scenario: Run with update command when project present
    Given created old howitzer project
    When I run `howitzer update` interactively
    And I type "y"
    And I type "n"
    And I type "i"
    Then the output should contain:
    """
      * Config files generation ...
          Identical 'config/custom.yml' file
          Added 'config/default.yml' file
      * Root files generation ...
          Added '.gitignore' file
          Conflict with 'Gemfile' file
            Overwrite 'Gemfile' file? [Yn]:          Forced 'Gemfile' file
          Identical 'Rakefile' file
          Conflict with 'boot.rb' file
            Overwrite 'boot.rb' file? [Yn]:          Skipped 'boot.rb' file
      * Cucumber integration to the framework ...
          Identical 'features/step_definitions/common_steps.rb' file
          Identical 'features/support/env.rb' file
          Identical 'features/support/transformers.rb' file
          Identical 'features/example.feature' file
          Identical 'tasks/cucumber.rake' file
          Identical 'config/cucumber.yml' file
      * RSpec integration to the framework ...
          Identical 'spec/spec_helper.rb' file
          Identical 'spec/example_spec.rb' file
          Identical 'tasks/rspec.rake' file
    """
    And the exit status should be 0
    When I run `howitzer update` interactively
    And I type "y"
    Then the output should contain:
    """
      * Config files generation ...
          Identical 'config/custom.yml' file
          Identical 'config/default.yml' file
      * Root files generation ...
          Identical '.gitignore' file
          Identical 'Gemfile' file
          Identical 'Rakefile' file
          Conflict with 'boot.rb' file
            Overwrite 'boot.rb' file? [Yn]:          Forced 'boot.rb' file
      * Cucumber integration to the framework ...
          Identical 'features/step_definitions/common_steps.rb' file
          Identical 'features/support/env.rb' file
          Identical 'features/support/transformers.rb' file
          Identical 'features/example.feature' file
          Identical 'tasks/cucumber.rake' file
          Identical 'config/cucumber.yml' file
      * RSpec integration to the framework ...
          Identical 'spec/spec_helper.rb' file
          Identical 'spec/example_spec.rb' file
          Identical 'tasks/rspec.rake' file
    """
    And the exit status should be 0

  Scenario: Run with update command when project missing
    When I run `howitzer update`
    Then the output should contain:
    """
    error: Current directory is not Howitzer project
    """
    And the exit status should be 126

  Scenario Outline: Run with update command with help option
    When I run `howitzer update <option>`
    Then the output should contain exactly:
    """
    NAME
        update - Upgrade existing project

    SYNOPSIS
        howitzer [global options] update

    """
    And the exit status should be 0
  Examples:
    | option |
    | --help |
    | -h     |