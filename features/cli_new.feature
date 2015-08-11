Feature: Howitzer CLI New Project Creation

  Scenario: Run with new command without argument and options
    When I run `howitzer new`
    Then the output should contain exactly:
    """
    error: Please specify <PROJECT NAME>

    """
    And the exit status should be 64

  Scenario: Run with new command with argument and without options
    When I run `howitzer new test_automation`
    Then the output should contain exactly:
    """
    error: Provide --cucumber or --rspec option

    """
    And the exit status should be 64

  Scenario: Run with new command with argument and unknown option
    When I run `howitzer new test_automation --unknown`
    Then the output should contain:
    """
    error: Unknown option --unknown

    """
    And the exit status should be 64

  Scenario Outline: Run with new command with help option
    When I run `howitzer new <option>`
    Then the output should contain exactly:
    """
    NAME
        new - Generate new project

    SYNOPSIS
        howitzer [global options] new [command options] <PROJECT NAME>

    COMMAND OPTIONS
        -c, --cucumber - Integrate Cucumber
        -r, --rspec    - Integrate Rspec

    """
    And the exit status should be 0
  Examples:
    | option |
    | --help |
    | -h     |

  Scenario Outline: Run with new command with argument and with rspec option
    When I run `howitzer new test_automation <option>`
    Then the output should contain exactly:
    """
      * New project directory creation ...
          Created new './test_automation' folder
      * Config files generation ...
          Added 'config/custom.yml' file
          Added 'config/default.yml' file
      * PageOriented pattern structure generation ...
          Added 'pages/example_page.rb' file
          Added 'pages/example_menu.rb' file
      * Base rake task generation ...
          Added 'tasks/common.rake' file
      * Email example generation ...
          Added '/emails/example_email.rb' file
      * Root files generation ...
          Added '.gitignore' file
          Added 'Gemfile' file
          Added 'Rakefile' file
          Added 'boot.rb' file
      * RSpec integration to the framework ...
          Added 'spec/spec_helper.rb' file
          Added 'spec/example_spec.rb' file
          Added 'tasks/rspec.rake' file

    """
    Then a directory named "test_automation" should exist
    Then the following files should exist:
      | test_automation/config/custom.yml       |
      | test_automation/config/default.yml      |
      | test_automation/emails/example_email.rb |
      | test_automation/pages/example_menu.rb   |
      | test_automation/pages/example_page.rb   |
      | test_automation/spec/example_spec.rb    |
      | test_automation/spec/spec_helper.rb     |
      | test_automation/tasks/common.rake       |
      | test_automation/tasks/rspec.rake        |
      | test_automation/boot.rb                 |
      | test_automation/Gemfile                 |
      | test_automation/Rakefile                |
      | test_automation/.gitignore              |
    And the exit status should be 0
  Examples:
    | option  |
    | --rspec |
    | -r      |

  Scenario Outline: Run with new command with argument and with cucumber option
    When I run `howitzer new test_automation <option>`
    Then the output should contain exactly:
    """
      * New project directory creation ...
          Created new './test_automation' folder
      * Config files generation ...
          Added 'config/custom.yml' file
          Added 'config/default.yml' file
      * PageOriented pattern structure generation ...
          Added 'pages/example_page.rb' file
          Added 'pages/example_menu.rb' file
      * Base rake task generation ...
          Added 'tasks/common.rake' file
      * Email example generation ...
          Added '/emails/example_email.rb' file
      * Root files generation ...
          Added '.gitignore' file
          Added 'Gemfile' file
          Added 'Rakefile' file
          Added 'boot.rb' file
      * Cucumber integration to the framework ...
          Added 'features/step_definitions/common_steps.rb' file
          Added 'features/support/env.rb' file
          Added 'features/support/transformers.rb' file
          Added 'features/example.feature' file
          Added 'tasks/cucumber.rake' file
          Added 'config/cucumber.yml' file

    """
    Then a directory named "test_automation" should exist
    Then the following files should exist:
      | test_automation/config/cucumber.yml                       |
      | test_automation/config/custom.yml                         |
      | test_automation/config/default.yml                        |
      | test_automation/emails/example_email.rb                   |
      | test_automation/features/step_definitions/common_steps.rb |
      | test_automation/features/support/env.rb                   |
      | test_automation/features/support/transformers.rb          |
      | test_automation/features/example.feature                  |
      | test_automation/pages/example_menu.rb                     |
      | test_automation/pages/example_page.rb                     |
      | test_automation/tasks/common.rake                         |
      | test_automation/tasks/cucumber.rake                       |
      | test_automation/boot.rb                                   |
      | test_automation/Gemfile                                   |
      | test_automation/Rakefile                                  |
      | test_automation/.gitignore                                |
    And the exit status should be 0
  Examples:
    | option     |
    | --cucumber |
    | -c         |

  Scenario Outline: Run with new command with argument and with cucumber and rspec option
    When I run `howitzer new test_automation <options>`
    Then the output should contain exactly:
    """
    error: Provide --cucumber or --rspec option

    """
    And the exit status should be 64
  Examples:
    | options            |
    | --cucumber --rspec |
    | --rspec --cucumber |
    | -c -r              |
    | -r -c              |
    | -cr                |
    | -rc                |

  Scenario Outline: Run with new command with options and with rspec argument
    When I run `howitzer new <option> test_automation`
    Then the output should contain exactly:
    """
      * New project directory creation ...
          Created new './test_automation' folder
      * Config files generation ...
          Added 'config/custom.yml' file
          Added 'config/default.yml' file
      * PageOriented pattern structure generation ...
          Added 'pages/example_page.rb' file
          Added 'pages/example_menu.rb' file
      * Base rake task generation ...
          Added 'tasks/common.rake' file
      * Email example generation ...
          Added '/emails/example_email.rb' file
      * Root files generation ...
          Added '.gitignore' file
          Added 'Gemfile' file
          Added 'Rakefile' file
          Added 'boot.rb' file
      * RSpec integration to the framework ...
          Added 'spec/spec_helper.rb' file
          Added 'spec/example_spec.rb' file
          Added 'tasks/rspec.rake' file

    """
    Then a directory named "test_automation" should exist
    Then the following files should exist:
      | test_automation/config/custom.yml       |
      | test_automation/config/default.yml      |
      | test_automation/emails/example_email.rb |
      | test_automation/pages/example_menu.rb   |
      | test_automation/pages/example_page.rb   |
      | test_automation/spec/example_spec.rb    |
      | test_automation/spec/spec_helper.rb     |
      | test_automation/tasks/common.rake       |
      | test_automation/tasks/rspec.rake        |
      | test_automation/boot.rb                 |
      | test_automation/Gemfile                 |
      | test_automation/Rakefile                |
      | test_automation/.gitignore              |
    And the exit status should be 0
  Examples:
    | option  |
    | --rspec |
