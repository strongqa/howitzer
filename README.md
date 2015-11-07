# Howitzer

[![Join the chat at https://gitter.im/strongqa/howitzer](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/strongqa/howitzer?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Gem Version](http://img.shields.io/gem/v/howitzer.svg)][gem]
[![Build Status](https://travis-ci.org/strongqa/howitzer.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/strongqa/howitzer.svg)][gemnasium]
[![Code Climate](https://codeclimate.com/github/romikoops/howitzer.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/strongqa/howitzer/badge.png?branch=master)][coveralls]
[![License](http://img.shields.io/badge/license-MIT-blue.svg)][license]

[gem]: https://rubygems.org/gems/howitzer
[travis]: https://travis-ci.org/strongqa/howitzer
[gemnasium]: https://gemnasium.com/strongqa/howitzer
[codeclimate]: https://codeclimate.com/github/romikoops/howitzer
[coveralls]: https://coveralls.io/r/strongqa/howitzer?branch=master
[license]: https://github.com/strongqa/howitzer/blob/master/LICENSE

Howitzer is a Ruby-based framework for acceptance testing.

It was originally developed for testing web applications, but you can also use it for API testing and web service testing.

The framework was built with modern patterns, techniques, and tools in automated testing. For details, please see [Test Framework Design](https://github.com/strongqa/howitzer/wiki/Test-Framework-Design).

## Key Benefits
- Independent of test web application, its technologies and languages.
- Fast installation of the complete testing infrastructure (takes less than 5 minutes).
- Flexible configuration of the test framework.
- Possibility to choose between Cucumber, RSpec or Turnip BDD tool.
- Integration with SauceLabs, Testingbot, BrowserStack and MailGun web services.
- Easy tests support.
- Ability to execute tests against to both browserless driver and actual browsers with no changes in your tests.
- Searches for broken links.


## Documentation
Refer to the [GETTING STARTED](http://rubydoc.info/gems/howitzer/file/GETTING_STARTED.md) document to start working with *Howitzer*.

You can also find the Rdoc documentation on [Rubygems](https://rubygems.org/gems/howitzer).

## Related Products
* [Howitzer Example](https://github.com/strongqa/howitzer_example) – an example of Howitzer based project for demo web application.
* [Howitzer Stat](https://github.com/strongqa/howitzer_stat) – is the extension to Howitzer product. It is used for automated tests coverage visualization of web pages.

## Requirements
* Supported OS: Mac OS X, Linux, Windows
* [Ruby](https://www.ruby-lang.org/en/downloads/) 1.9.3+
* [DevKit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit#installation-instructions) (For **Windows** only)
* [PhantomJS](http://phantomjs.org/download.html)
* [ChromeDriver](https://code.google.com/p/selenium/wiki/ChromeDriver)
* [QT](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit) (For **webkit** driver only)

## Setup
To install, type

```bash
gem install howitzer
```

## Usage
Browse to a desired directory where a new project will be created.

To deploy the framework with [Cucumber](https://cucumber.io/), type:

```bash
howitzer new <PROJECT NAME> --cucumber
```

The following folders and files will be generated:
```
config/
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

With [Rspec](http://rspec.info/):

```bash
howitzer new <PROJECT NAME> --rspec
```

With [Turnip](https://github.com/jnicklas/turnip):

```bash
howitzer new <PROJECT NAME> --turnip
```

**Configuration**

Learn and specify correct default settings in the `config/default.yml` file. For more details, please refer to the original [sexy_settings](https://github.com/romikoops/sexy_settings) gem.

## Test Implementation Workflow

- Prepare features and scenarios
- Implement appropriate pages in the `pages` folder. For details, refer to  [Page Object Pattern](https://github.com/strongqa/howitzer/wiki/PageObject-pattern).
- Implement emails in `emails` folder.
- Implement scenarios:
  * For Cucumber:
    1. Read and learn [Cucumber Best Practices](https://github.com/strongqa/howitzer/wiki/Cucumber-Best-Practices)
    2. Implement step definitions in the `features/step_definitions/common_steps.rb` file.
  * For Rspec: Use [DSL](https://github.com/jnicklas/capybara/blob/master/lib/capybara/rspec/features.rb) provided by Capybara to create descriptive acceptance tests.
- Debug feature against to desired driver.
- Enjoy it!

## Rake Tasks

You can get a list of all available tasks by typing the following command:

```bash
rake -T

```

## Upgrading Howitzer
Before attempting to upgrade an existing project, you should be sure you have a good reason to upgrade. You need to balance several factors: the need for new features, the increasing difficulty of finding support for old code, and your available time and skills, to name a few.

From version _v1.1.0_ howitzer provides **howitzer update** command. After updating the Howitzer version in the Gemfile, run this rake task. This will help you with the creation of new files and changes of old files in an interactive session.

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

## Additional Information
* [Rubygems](https://rubygems.org/gems/howitzer)
* [Mailing list](https://groups.google.com/forum/#!forum/howitzer_ruby)
* [Issues](https://github.com/strongqa/howitzer/issues)
* [Developer chat](https://gitter.im/strongqa/howitzer)

Contributing
------------

Please see [CONTRIBUTING.md](https://github.com/strongqa/howitzer/blob/master/CONTRIBUTING.md).

howitzer was originally designed by Roman Parashchenko and is now maintained by StrongQA team. You can find list of contributors here [open source
community](https://github.com/strongqa/howitzer/graphs/contributors).

License
-------

howitzer is Copyright © 2012-2015 Roman Parashchenko and StrongQA. It is free
software, and may be redistributed under the terms specified in the
[LICENSE](/LICENSE) file.

About StrongQA
----------------

![StrongQA](http://strongqa.com/head_logo_big.png)

howitzer is maintained and funded by StrongQA, Ltd.
The names and logos for StrongQA are trademarks of StrongQA, Ltd.

We love open source software!
See [our other projects][testing_solutions] or [hire us][hire] to consult and develop testing solutions.

[testing_solutions]: http://strongqa.com/testing_solutions/?utm_source=github
[hire]: https://strongqa.com?utm_source=github
