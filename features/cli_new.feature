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
    error: Provide --cucumber, --rspec or --turnip option

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
        -t, --turnip   - Integrate Turnip

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
          Added 'config/capybara.rb' file
          Added 'config/default.yml' file
      * PageOriented pattern structure generation ...
          Added 'web/pages/example_page.rb' file
          Added 'web/sections/menu_section.rb' file
      * Base rake task generation ...
          Added 'tasks/common.rake' file
      * Email example generation ...
          Added '/emails/example_email.rb' file
      * Root files generation ...
          Added '.gitignore' file
          Added 'Rakefile' file
          Added 'boot.rb' file
          Added template 'Gemfile.erb' with params '{:r=>true, :rspec=>true, :c=>false, :cucumber=>false, :t=>false, :turnip=>false}' to destination 'Gemfile'
      * Pre-requisites integration to the framework ...
          Added 'prerequisites/factory_girl.rb' file
          Added 'prerequisites/her.rb' file
          Added 'prerequisites/factories/users.rb' file
          Added 'prerequisites/models/user.rb' file
      * RSpec integration to the framework ...
          Added 'spec/spec_helper.rb' file
          Added 'spec/example_spec.rb' file
          Added 'tasks/rspec.rake' file

    """
    Then a directory named "test_automation" should exist
    Then the following files should exist:
      | test_automation/config/custom.yml                |
      | test_automation/config/capybara.rb               |
      | test_automation/config/default.yml               |
      | test_automation/emails/example_email.rb          |
      | test_automation/web/sections/menu_section.rb     |
      | test_automation/web/pages/example_page.rb        |
      | test_automation/prerequisites/factory_girl.rb    |
      | test_automation/prerequisites/her.rb             |
      | test_automation/prerequisites/factories/users.rb |
      | test_automation/prerequisites/models/user.rb     |
      | test_automation/spec/example_spec.rb             |
      | test_automation/spec/spec_helper.rb              |
      | test_automation/tasks/common.rake                |
      | test_automation/tasks/rspec.rake                 |
      | test_automation/boot.rb                          |
      | test_automation/Gemfile                          |
      | test_automation/Rakefile                         |
      | test_automation/.gitignore                       |
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
          Added 'config/capybara.rb' file
          Added 'config/default.yml' file
      * PageOriented pattern structure generation ...
          Added 'web/pages/example_page.rb' file
          Added 'web/sections/menu_section.rb' file
      * Base rake task generation ...
          Added 'tasks/common.rake' file
      * Email example generation ...
          Added '/emails/example_email.rb' file
      * Root files generation ...
          Added '.gitignore' file
          Added 'Rakefile' file
          Added 'boot.rb' file
          Added template 'Gemfile.erb' with params '{:c=>true, :cucumber=>true, :r=>false, :rspec=>false, :t=>false, :turnip=>false}' to destination 'Gemfile'
      * Pre-requisites integration to the framework ...
          Added 'prerequisites/factory_girl.rb' file
          Added 'prerequisites/her.rb' file
          Added 'prerequisites/factories/users.rb' file
          Added 'prerequisites/models/user.rb' file
      * Cucumber integration to the framework ...
          Added 'features/step_definitions/common_steps.rb' file
          Added 'features/support/env.rb' file
          Added 'features/support/transformers.rb' file
          Added 'features/example.feature' file
          Added 'tasks/cucumber.rake' file

    """
    Then a directory named "test_automation" should exist
    Then the following files should exist:
      | test_automation/config/custom.yml                         |
      | test_automation/config/capybara.rb                        |
      | test_automation/config/default.yml                        |
      | test_automation/emails/example_email.rb                   |
      | test_automation/features/step_definitions/common_steps.rb |
      | test_automation/features/support/env.rb                   |
      | test_automation/features/support/transformers.rb          |
      | test_automation/features/example.feature                  |
      | test_automation/web/sections/menu_section.rb                 |
      | test_automation/web/pages/example_page.rb                 |
      | test_automation/prerequisites/factory_girl.rb    |
      | test_automation/prerequisites/her.rb             |
      | test_automation/prerequisites/factories/users.rb |
      | test_automation/prerequisites/models/user.rb     |
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

  Scenario Outline: Run with new command with argument and with turnip option
    When I run `howitzer new test_automation <option>`
    Then the output should contain exactly:
    """
      * New project directory creation ...
          Created new './test_automation' folder
      * Config files generation ...
          Added 'config/custom.yml' file
          Added 'config/capybara.rb' file
          Added 'config/default.yml' file
      * PageOriented pattern structure generation ...
          Added 'web/pages/example_page.rb' file
          Added 'web/sections/menu_section.rb' file
      * Base rake task generation ...
          Added 'tasks/common.rake' file
      * Email example generation ...
          Added '/emails/example_email.rb' file
      * Root files generation ...
          Added '.gitignore' file
          Added 'Rakefile' file
          Added 'boot.rb' file
          Added template 'Gemfile.erb' with params '{:t=>true, :turnip=>true, :c=>false, :cucumber=>false, :r=>false, :rspec=>false}' to destination 'Gemfile'
      * Pre-requisites integration to the framework ...
          Added 'prerequisites/factory_girl.rb' file
          Added 'prerequisites/her.rb' file
          Added 'prerequisites/factories/users.rb' file
          Added 'prerequisites/models/user.rb' file
      * Turnip integration to the framework ...
          Added '.rspec' file
          Added 'spec/spec_helper.rb' file
          Added 'spec/turnip_helper.rb' file
          Added 'spec/acceptance/example.feature' file
          Added 'spec/steps/common_steps.rb' file
          Added 'tasks/turnip.rake' file

    """
    Then a directory named "test_automation" should exist
    Then the following files should exist:
      | test_automation/config/custom.yml                         |
      | test_automation/config/capybara.rb                        |
      | test_automation/config/default.yml                        |
      | test_automation/emails/example_email.rb                   |
      | test_automation/web/sections/menu_section.rb              |
      | test_automation/web/pages/example_page.rb                 |
      | test_automation/tasks/common.rake                         |
      | test_automation/tasks/turnip.rake                         |
      | test_automation/spec/spec_helper.rb                       |
      | test_automation/spec/turnip_helper.rb                     |
      | test_automation/spec/acceptance/example.feature           |
      | test_automation/spec/steps/common_steps.rb                |
      | test_automation/.rspec                                    |
      | test_automation/boot.rb                                   |
      | test_automation/Gemfile                                   |
      | test_automation/Rakefile                                  |
      | test_automation/.gitignore                                |
    And the exit status should be 0
    Examples:
      | option     |
      | --turnip   |
      | -t         |

  Scenario Outline: Run with new command with argument and option
    When I run `howitzer new test_automation <options>`
    Then the output should contain exactly:
    """
    error: Provide --cucumber, --rspec or --turnip option

    """
    And the exit status should be 64
  Examples:
    | options             |
    | --cucumber --rspec  |
    | --rspec --cucumber  |
    | --cucumber --turnip |
    | --turnip --cucumber |
    | --rspec --turnip    |
    | --turnip --rspec    |
    | -c -t               |
    | -t -c               |
    | -c -r               |
    | -r -c               |
    | -r -t               |
    | -t -r               |
    | -cr                 |
    | -rc                 |
    | -ct                 |
    | -tc                 |
    | -rt                 |
    | -tr                 |
    | --cucumber --rspec --turnip    |
    | --cucumber --turnip --rspec    |
    | --rspec --cucumber --turnip    |
    | --rspec --turnip --cucumber    |
    | --turnip --cucumber --rspec    |
    | --turnip --rspec --cucumber    |
    | -c -r -t                       |
    | -c -t -r                       |
    | -r -c -t                       |
    | -r -t -c                       |
    | -t -c -r                       |
    | -t -r -c                       |
    | -crt                           |
    | -ctr                           |
    | -rct                           |
    | -rtc                           |
    | -tcr                           |
    | -trc                           |

  Scenario Outline: Run with new command with options and with rspec argument
    When I run `howitzer new <option> test_automation`
    Then the output should contain exactly:
    """
      * New project directory creation ...
          Created new './test_automation' folder
      * Config files generation ...
          Added 'config/custom.yml' file
          Added 'config/capybara.rb' file
          Added 'config/default.yml' file
      * PageOriented pattern structure generation ...
          Added 'web/pages/example_page.rb' file
          Added 'web/sections/menu_section.rb' file
      * Base rake task generation ...
          Added 'tasks/common.rake' file
      * Email example generation ...
          Added '/emails/example_email.rb' file
      * Root files generation ...
          Added '.gitignore' file
          Added 'Rakefile' file
          Added 'boot.rb' file
          Added template 'Gemfile.erb' with params '{:r=>true, :rspec=>true, :c=>false, :cucumber=>false, :t=>false, :turnip=>false}' to destination 'Gemfile'
      * Pre-requisites integration to the framework ...
          Added 'prerequisites/factory_girl.rb' file
          Added 'prerequisites/her.rb' file
          Added 'prerequisites/factories/users.rb' file
          Added 'prerequisites/models/user.rb' file
      * RSpec integration to the framework ...
          Added 'spec/spec_helper.rb' file
          Added 'spec/example_spec.rb' file
          Added 'tasks/rspec.rake' file

    """
    Then a directory named "test_automation" should exist
    Then the following files should exist:
      | test_automation/config/custom.yml                |
      | test_automation/config/capybara.rb               |
      | test_automation/config/default.yml               |
      | test_automation/emails/example_email.rb          |
      | test_automation/web/sections/menu_section.rb     |
      | test_automation/web/pages/example_page.rb        |
      | test_automation/prerequisites/factory_girl.rb    |
      | test_automation/prerequisites/her.rb             |
      | test_automation/prerequisites/factories/users.rb |
      | test_automation/prerequisites/models/user.rb     |
      | test_automation/spec/example_spec.rb             |
      | test_automation/spec/spec_helper.rb              |
      | test_automation/tasks/common.rake                |
      | test_automation/tasks/rspec.rake                 |
      | test_automation/boot.rb                          |
      | test_automation/Gemfile                          |
      | test_automation/Rakefile                         |
      | test_automation/.gitignore                       |
    And the exit status should be 0
  Examples:
    | option  |
    | --rspec |
