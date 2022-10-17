Feature: Howitzer CLI Update Existing Project

  Scenario: Run with update command when rspec based project present
    Given created old howitzer project based on rspec
    When I run `howitzer update` interactively
    And I type "y"
    And I type "y"
    And I type "n"
    And I type "y"
    And I type "i"
    Then the output should contain:
    """
      * Config files generation ...
          Identical 'config/boot.rb' file
          Identical 'config/custom.yml' file
          Identical 'config/capybara.rb' file
          Added 'config/default.yml' file
          Identical 'config/drivers/browserstack.rb' file
          Identical 'config/drivers/crossbrowsertesting.rb' file
          Identical 'config/drivers/headless_chrome.rb' file
          Identical 'config/drivers/headless_firefox.rb' file
          Identical 'config/drivers/lambdatest.rb' file
          Identical 'config/drivers/sauce.rb' file
          Identical 'config/drivers/selenium.rb' file
          Identical 'config/drivers/selenium_grid.rb' file
          Identical 'config/drivers/testingbot.rb' file
      * PageOriented pattern structure generation ...
          Identical 'web/pages/example_page.rb' file
          Identical 'web/sections/menu_section.rb' file
      * Base rake task generation ...
          Identical 'tasks/common.rake' file
      * Email example generation ...
          Identical '/emails/example_email.rb' file
      * Pre-requisites integration to the framework ...
          Identical 'prerequisites/factory_bot.rb' file
          Identical 'prerequisites/factories/users.rb' file
          Identical 'prerequisites/models/base.rb' file
          Identical 'prerequisites/models/user.rb' file
      * Root files generation ...
          Added '.gitignore' file
          Added '.dockerignore' file
          Identical 'Dockerfile' file
          Conflict with 'Rakefile' file
            Overwrite 'Rakefile' file? [Yn]:          Forced 'Rakefile' file
          Added template '.rubocop.yml.erb' with params '{:rspec=>true}' to destination '.rubocop.yml'
          Conflict with 'docker-compose.yml' template
            Overwrite 'docker-compose.yml' template? [Yn]:          Forced 'docker-compose.yml' template
          Conflict with 'Gemfile' template
            Overwrite 'Gemfile' template? [Yn]:          Skipped 'Gemfile' template
          Conflict with 'README.md' template
            Overwrite 'README.md' template? [Yn]:          Forced 'README.md' template
      * RSpec integration to the framework ...
          Identical 'spec/spec_helper.rb' file
          Identical 'spec/example_spec.rb' file
          Identical 'tasks/rspec.rake' file
    """
    And the exit status should be 0
    When I run `howitzer update` interactively
    And I type "y"
    And I type "y"
    And I type "y"
    And I type "y"
    Then the output should contain:
    """
      * Config files generation ...
          Identical 'config/boot.rb' file
          Identical 'config/custom.yml' file
          Identical 'config/capybara.rb' file
          Identical 'config/default.yml' file
          Identical 'config/drivers/browserstack.rb' file
          Identical 'config/drivers/crossbrowsertesting.rb' file
          Identical 'config/drivers/headless_chrome.rb' file
          Identical 'config/drivers/headless_firefox.rb' file
          Identical 'config/drivers/lambdatest.rb' file
          Identical 'config/drivers/sauce.rb' file
          Identical 'config/drivers/selenium.rb' file
          Identical 'config/drivers/selenium_grid.rb' file
          Identical 'config/drivers/testingbot.rb' file
      * PageOriented pattern structure generation ...
          Identical 'web/pages/example_page.rb' file
          Identical 'web/sections/menu_section.rb' file
      * Base rake task generation ...
          Identical 'tasks/common.rake' file
      * Email example generation ...
          Identical '/emails/example_email.rb' file
      * Pre-requisites integration to the framework ...
          Identical 'prerequisites/factory_bot.rb' file
          Identical 'prerequisites/factories/users.rb' file
          Identical 'prerequisites/models/base.rb' file
          Identical 'prerequisites/models/user.rb' file
      * Root files generation ...
          Identical '.gitignore' file
          Identical '.dockerignore' file
          Identical 'Dockerfile' file
          Identical 'Rakefile' file
          Conflict with '.rubocop.yml' template
            Overwrite '.rubocop.yml' template? [Yn]:          Forced '.rubocop.yml' template
          Conflict with 'docker-compose.yml' template
            Overwrite 'docker-compose.yml' template? [Yn]:          Forced 'docker-compose.yml' template
          Conflict with 'Gemfile' template
            Overwrite 'Gemfile' template? [Yn]:          Forced 'Gemfile' template
          Conflict with 'README.md' template
            Overwrite 'README.md' template? [Yn]:          Forced 'README.md' template
      * RSpec integration to the framework ...
          Identical 'spec/spec_helper.rb' file
          Identical 'spec/example_spec.rb' file
          Identical 'tasks/rspec.rake' file
    """
    And the exit status should be 0

  Scenario: Run with update command when cucumber based project present
    Given created old howitzer project based on cucumber
    When I run `howitzer update` interactively
    And I type "y"
    And I type "y"
    And I type "n"
    And I type "y"
    And I type "i"
    Then the output should contain:
    """
      * Config files generation ...
          Identical 'config/boot.rb' file
          Identical 'config/custom.yml' file
          Identical 'config/capybara.rb' file
          Added 'config/default.yml' file
          Identical 'config/drivers/browserstack.rb' file
          Identical 'config/drivers/crossbrowsertesting.rb' file
          Identical 'config/drivers/headless_chrome.rb' file
          Identical 'config/drivers/headless_firefox.rb' file
          Identical 'config/drivers/lambdatest.rb' file
          Identical 'config/drivers/sauce.rb' file
          Identical 'config/drivers/selenium.rb' file
          Identical 'config/drivers/selenium_grid.rb' file
          Identical 'config/drivers/testingbot.rb' file
      * PageOriented pattern structure generation ...
          Identical 'web/pages/example_page.rb' file
          Identical 'web/sections/menu_section.rb' file
      * Base rake task generation ...
          Identical 'tasks/common.rake' file
      * Email example generation ...
          Identical '/emails/example_email.rb' file
      * Pre-requisites integration to the framework ...
          Identical 'prerequisites/factory_bot.rb' file
          Identical 'prerequisites/factories/users.rb' file
          Identical 'prerequisites/models/base.rb' file
          Identical 'prerequisites/models/user.rb' file
      * Root files generation ...
          Added '.gitignore' file
          Added '.dockerignore' file
          Identical 'Dockerfile' file
          Conflict with 'Rakefile' file
            Overwrite 'Rakefile' file? [Yn]:          Forced 'Rakefile' file
          Added template '.rubocop.yml.erb' with params '{:cucumber=>true}' to destination '.rubocop.yml'
          Conflict with 'docker-compose.yml' template
            Overwrite 'docker-compose.yml' template? [Yn]:          Forced 'docker-compose.yml' template
          Conflict with 'Gemfile' template
            Overwrite 'Gemfile' template? [Yn]:          Skipped 'Gemfile' template
          Conflict with 'README.md' template
            Overwrite 'README.md' template? [Yn]:          Forced 'README.md' template
      * Cucumber integration to the framework ...
          Identical 'features/step_definitions/common_steps.rb' file
          Identical 'features/support/env.rb' file
          Identical 'features/support/hooks.rb' file
          Identical 'features/support/transformers.rb' file
          Identical 'features/example.feature' file
          Identical 'tasks/cucumber.rake' file
    """
    And the exit status should be 0

  Scenario: Run with update command when turnip based project present
    Given created old howitzer project based on turnip
    When I run `howitzer update` interactively
    And I type "y"
    And I type "y"
    And I type "y"
    Then the output should contain:
    """
      * Config files generation ...
          Identical 'config/boot.rb' file
          Identical 'config/custom.yml' file
          Identical 'config/capybara.rb' file
          Identical 'config/default.yml' file
          Identical 'config/drivers/browserstack.rb' file
          Identical 'config/drivers/crossbrowsertesting.rb' file
          Identical 'config/drivers/headless_chrome.rb' file
          Identical 'config/drivers/headless_firefox.rb' file
          Identical 'config/drivers/lambdatest.rb' file
          Identical 'config/drivers/sauce.rb' file
          Identical 'config/drivers/selenium.rb' file
          Identical 'config/drivers/selenium_grid.rb' file
          Identical 'config/drivers/testingbot.rb' file
      * PageOriented pattern structure generation ...
          Identical 'web/pages/example_page.rb' file
          Identical 'web/sections/menu_section.rb' file
      * Base rake task generation ...
          Identical 'tasks/common.rake' file
      * Email example generation ...
          Identical '/emails/example_email.rb' file
      * Pre-requisites integration to the framework ...
          Identical 'prerequisites/factory_bot.rb' file
          Identical 'prerequisites/factories/users.rb' file
          Identical 'prerequisites/models/base.rb' file
          Identical 'prerequisites/models/user.rb' file
      * Root files generation ...
          Added '.gitignore' file
          Added '.dockerignore' file
          Identical 'Dockerfile' file
          Identical 'Rakefile' file
          Added template '.rubocop.yml.erb' with params '{:turnip=>true}' to destination '.rubocop.yml'
          Conflict with 'docker-compose.yml' template
            Overwrite 'docker-compose.yml' template? [Yn]:          Forced 'docker-compose.yml' template
          Conflict with 'Gemfile' template
            Overwrite 'Gemfile' template? [Yn]:          Forced 'Gemfile' template
          Conflict with 'README.md' template
            Overwrite 'README.md' template? [Yn]:          Forced 'README.md' template
      * Turnip integration to the framework ...
          Added '.rspec' file
          Identical 'spec/spec_helper.rb' file
          Identical 'spec/turnip_helper.rb' file
          Identical 'spec/acceptance/example.feature' file
          Identical 'spec/steps/common_steps.rb' file
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
