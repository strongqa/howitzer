# Howitzer
[![Gem Version](http://img.shields.io/gem/v/howitzer.svg)][gem]
[![Build Status](https://travis-ci.org/strongqa/howitzer.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/romikoops/howitzer.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/romikoops/howitzer.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/strongqa/howitzer/badge.png?branch=develop)][coveralls]
[![License](http://img.shields.io/badge/license-MIT-blue.svg)][license]

[gem]: https://rubygems.org/gems/howitzer
[travis]: https://travis-ci.org/strongqa/howitzer
[gemnasium]: https://gemnasium.com/romikoops/howitzer
[codeclimate]: https://codeclimate.com/github/romikoops/howitzer
[coveralls]: https://coveralls.io/r/strongqa/howitzer?branch=develop
[license]: https://github.com/strongqa/howitzer/blob/master/LICENSE

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
* Supported OS: Mac OS X, Linux, Windows
* Ruby 1.9.3+
* [DevKit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit#installation-instructions)(For **Windows** only)
* [PhantomJS](http://phantomjs.org/download.html)
* [ChromeDriver](https://code.google.com/p/selenium/wiki/ChromeDriver)

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

## Test implementation workflow

- Prepare Features and Scenarios
- Implement appropriate pages in `pages` folder. For details, see [Page Object Pattern](https://github.com/strongqa/howitzer/wiki/PageObject-pattern).
- Implement emails in `emails` folder.
- Implement scenarios:
  * Cucumber:
    1. Read and learn [Cucumber Best Practices](https://github.com/strongqa/howitzer/wiki/Cucumber-Best-Practices)
    2. Implement step definitions in `features/step_definitions/common_steps.rb` file.
  * Rspec: Use [DSL](https://github.com/jnicklas/capybara/blob/master/lib/capybara/rspec/features.rb) provided by Capybara for creating descriptive acceptance tests
- Debug feature against to desired driver.
- Enjoy it!

## Rake tasks

You can list all available tasks with next command

```bash
rake -T
```

## Upgrading Howitzer
Before attempting to upgrade an existing project, you should be sure you have a good reason to upgrade. You need to balance several factors: the need for new features, the increasing difficulty of finding support for old code, and your available time and skills, to name a few.

From version _v1.1.0_ howitzer provides howitzer:update command. After updating the Howitzer version in the Gemfile, run this rake task. This will help you with the creation of new files and changes of old files in an interactive session.

```
$ howitzer update
        *  Config files generation ...
            Identical 'config/custom.yml' file
            Added 'config/default.yml' file
        * Root files generation ...
            Added '.gitignore' file
            Conflict with 'Gemfile' file
              Overwrite 'Gemfile' file? [Yn]:Y
                Forced 'Gemfile' file
            Identical 'Rakefile' file
            Conflict with 'boot.rb' file
              Overwrite 'boot.rb' file? [Yn]:n
                Skipped 'boot.rb' file

...
```
Don't forget to review the difference, to see if there were any unexpected changes and merge them. It is easy if your project is under revision control systems like _Git_.

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
