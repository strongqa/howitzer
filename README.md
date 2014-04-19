# Howitzer

[![Build Status](https://travis-ci.org/strongqa/howitzer.svg?branch=develop)](https://travis-ci.org/strongqa/howitzer)
[![Dependency Status](https://gemnasium.com/romikoops/howitzer.png)](https://gemnasium.com/romikoops/howitzer)
[![Code Climate](https://codeclimate.com/github/romikoops/howitzer.png)](https://codeclimate.com/github/romikoops/howitzer)

Howitzer is Ruby based framework for acceptance testing.

Initially it was developed for testing of web applications, but it is applicable to testing of web services or some API as well.
The framework uses modern patterns, techniques and tools in automated testing area. For details, please see [Test Framework Design](https://github.com/strongqa/howitzer/wiki/Test-Framework-Design).

## Key benefits
- Independent of test web application, its technologies and lanquage.
- Deploy all test infrastructure for 5 minutes.
- Flexible test framework configuration.
- Ability to choose desired BDD tool (Cucumber or RSpec)
- Itegration with SauceLabs, Testingbot and Mailgun web services.
- Easy to support tests in actual state.
- Ability to execute tests against to both browserless driver and actual browsers with no changes in your tests.
- Ability to check all links are valid


## Documentation
See [GETTING_STARTED](https://github.com/strongqa/howitzer/blob/develop/GETTING_STARTED.md) how to work with *howitzer*.

Also you can find Rdoc documentation on [Rubygems](https://rubygems.org/gems/howitzer).

## Related products
* [Howitzer Example](https://github.com/strongqa/howitzer_example) - Demo Rails application and Acceptance tests
* [Howitzer Stat](https://github.com/strongqa/howitzer_stat) - Howitzer extension for test coverage visualization of web web pages

## Requirements
Ruby 1.9.3+

## Setup
To install, type

```bash
gem install howitzer
```

## Usage
navigate to desired directory where new project will be created

To deploy the framework with Cucumber, type:

```bash
howitzer new <PROJECT NAME> --cucumber
```

This command will generate next folders and files:
```
config/
  cucumber.yml
  default.yml
  custom.yml
tasks/
  common.rake
  cucumber.rake
  rspec.rake
emails/
  example_email.rb
features/
  support/env.rb
  step_definitions/common_steps.rb
  example.feature
pages/
  example_page.rb
  example_menu.rb
boot.rb
Gemfile
Rakefile
.gitignore
```

With Rspec:

```bash
howitzer new <PROJECT NAME> --rspec
```

With both the ones:

```bash
howitzer new <PROJECT NAME> --cucumber --rspec
```

### Configuration
Learn and specify correct default settings in `config/default.yml` file. For details, please see original [sexy_settings](https://github.com/romikoops/sexy_settings) gem.

## Test implementation workflow (with Cucumber)

- Read and learn [Cucumber Best Practices](https://github.com/strongqa/howitzer/wiki/Cucumber-Best-Practices)
- Prepare some feature with scenarios in `features/some.feature` file.
- Implement step definitions in `features/step_definitions/common_steps.rb` file.
- Implement appropriate pages in `pages` folder. For details, see [Page Object Pattern](https://github.com/strongqa/howitzer/wiki/PageObject-pattern).
- Debug feature.
- Enjoy it!

## Rake tasks

You can list all available tasks with next command

```bash
rake -T
```

## More information
* [Rubygems](https://rubygems.org/gems/howitzer)
* [Mailing list](https://groups.google.com/forum/#!forum/howitzer_ruby)
* [Issues](https://github.com/strongqa/howitzer/issues)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
