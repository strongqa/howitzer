# Howitzer

[![Build Status](https://api.travis-ci.org/romikoops/howitzer.png)](http://travis-ci.org/romikoops/howitzer)
[![Dependency Status](https://gemnasium.com/romikoops/howitzer.png)](https://gemnasium.com/romikoops/howitzer)
[![Code Climate](https://codeclimate.com/github/romikoops/howitzer.png)](https://codeclimate.com/github/romikoops)

Howitzer is Ruby based framework for acceptance testing.

Initially it was developed for testing of web applications, but it is applicable to testing of web services or some API as well.
The framework uses modern patterns, techniques and tools in automated testing area. For details, please see [Test Framework Design](https://github.com/romikoops/howitzer/wiki/Test-Framework-Design).

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
See [GETTING_STARTED](https://github.com/romikoops/howitzer/blob/develop/GETTING_STARTED.md) how to work with *howitzer*.

Also you can find Rdoc documentation on [Rubygems](https://rubygems.org/gems/howitzer).

## Requirements
Ruby 1.9.3+

## Setup
To install, type

```bash
sudo gem install howitzer
```

## Usage
To deploy the framework, type:

```bash
mkdir test_automation
cd test_automation
```

Then for Cucumber:

```bash
howitzer install --cucumber
```

For Rspec:

```bash
howitzer install --rspec
```

Or for both the ones:

```bash
howitzer install --cucumber --rspec
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
### Configuration
Learn and specify correct default settings in `config/default.yml` file. For details, please see original [sexy_settings](https://github.com/romikoops/sexy_settings) gem.

## Test implementation workflow

- Prepare some feature with scenarios in `features/some.feature` file.
- Implement step definitions in `features/step_definitions/common_steps.rb` file.
- Implement appropriate pages in `pages` folder. For details, see [Page Object Pattern](https://github.com/romikoops/howitzer/wiki/PageObject-pattern).
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
* [Issues](https://github.com/romikoops/howitzer/issues)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
