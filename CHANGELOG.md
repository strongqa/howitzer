## [In git](https://github.com/strongqa/howitzer/compare/v2.0.3...master)

### New Features
- Integrate CrossBrowserTesting
- Mailtrap support added
- Gmail support added
- Colorized output added
- New option **user_agent**, allows custom user agent setup 
- **mailgun_sleep_time** deprecated, **mail_sleep_time** used instead for all mail adapters
- Capybara drivers configuration were split to separate files

### Bugfixes
- **window_maximized** option fixed for chrome browser on MacOS

## [v2.0.3](https://github.com/strongqa/howitzer/compare/v2.0.2...v2.0.3)

### New Features
- Integrate Google Chrome Headless
- Stop supported **mailgun_idle_timeout** deprecated setting
- Added maintenance instructions for releasing

### Bugfixes
- [#222](https://github.com/strongqa/howitzer/issues/222) fix issue with incorrect iframe scope identifying

## [v2.0.2](https://github.com/strongqa/howitzer/compare/v2.0.1...v2.0.2)

### New Features
- Integrate rspec-wait gem
- Support Ruby 2.4.0
- Support Selenium 3
- Integrate cuke-sniffer gem
- Activate rspec disable_monkey_patching! mode by default
- Support capybara frame options
- Add element_presence argument validation
- Review and improve tests quality

### Bugfixes
- Fix element capybara options merging
- [#211](https://github.com/strongqa/howitzer/issues/211) Validation for iframe does not operate as intended
- [#210](https://github.com/strongqa/howitzer/issues/210) Options like "wait" can not be used with iframe methods

## [v2.0.1](https://github.com/strongqa/howitzer/compare/v2.0.0...v2.0.1)

### New Features
- New rubocop changes supporting
- Add custom page url processor supporting
- Limited Selenium to v2.x
- Add ability to use instance variables and methods from outer cotext in page dsl
- Add wait time dsl method for particular email
- Implement wait_for_xxx_element method for sync
- Implement within_xxx_element method like Capybara.within

### Bugfixes
- [#188](https://github.com/strongqa/howitzer/issues/188) Page validation by element presence does not work properly
- [#191](https://github.com/strongqa/howitzer/issues/191) Generated project is broken
- [#195](https://github.com/strongqa/howitzer/issues/195) Incorrect parameters passing in lambda locators
- [#200](https://github.com/strongqa/howitzer/issues/200) capybara-screenshot does not work
- [#205](https://github.com/strongqa/howitzer/issues/205) Fix incorrect page identification on failed test
- Fix issue for IE in configs
- Fix issue found in generated prerequisites

## [v2.0.0](https://github.com/strongqa/howitzer/compare/v1.1.1...v2.0.0)

### New Features
- Added REST API prerequisites with FactoryGirl
- Added Turnip supporting
- Restricted using several bdd frameworks at the same time
- Removed Opera browser supporting
- Integrated Rubocop
- Stopped Ruby supporting less than v2.2.2
- Introduced /web folder for page object elements
- Moved capybara settings to framework side
- Integrated Capybara screenshots
- Renamed and restructured default settings
- Placed everything to own namespace
- Introduced "subject" dsl method for emails
- Moved framework dependent libraries from the gem
- Introduced common tag groups for all BDD frameworks
- Stopped Rawler supporting
- Reimplemented page dsl methods from scratch
- Introduced sections and iframes
- Introduced email adapters
- Stopped supporting of output to txt file
- Removed raising error on log.error
- Removed locator storage
- Prevented capybara form dsl method usage
- Introduced new Page.on method

## [v1.1.1](https://github.com/strongqa/howitzer/compare/v1.1.0...v1.1.1)

### Bugfixes
- fixed problem with Mailgun
- fixed problems with gems

## [v1.1.0](https://github.com/strongqa/howitzer/compare/v1.0.2...v1.1.0)

### New Features
- Simplified upgrading process(`howitzer update`)
- Added new Rubies supporting (2.1.4-2.2.2)
- Added Selenium Grid supporting
- Added Browserstack supporting
- Added windows maximization in tests
- Added Safari supporting
- Added general framework rake tasks
- Migrated to Cucumber 2.x
- Migrated to Rspec 3.x
- Actualized other dependencies
- Updated and extended documentation.
- Improved unit test coverage
- Added integration with [coveralls.io](https://coveralls.io/r/strongqa/howitzer)
- Integrated YardDoc
- Integrated Gitter

### Bugfixes
- Fixed issue with loading ActiveSupport

## [v1.0.2](https://github.com/strongqa/howitzer/compare/v1.0.1...v1.0.2)

### New Features
- Added Ruby 2.1 supporting
- Added Windows Supporting
- Improved project documentation
- Simplified new project creation
- Rewritten Mailgun integration to support Fabruary changes
- Created [Howitzer_example](https://github.com/strongqa/howitzer_example)
- Moved from personal github account to organization
- Added supporting of native selenium phantomjs driver
- Implemented smart page identification
- Rewritten command line interface and covered by acceptance tests fully
- Simplified DataStorage clearing after each tests

### Bugfixes
- Fixed reset session after each scenario against to IE
- Corrected default Cucumber and Rspec formatters
- Minor bug fixing and code refactoring

## [v1.0.1](https://github.com/strongqa/howitzer/compare/v1.0...v1.0.1)

### Bugfixes
- Fixed unit tests
- Fixed correct Ruby version supporting

## [v1.0](https://github.com/strongqa/howitzer/compare/v0.0.3...v1.0)

It is major release, so there are many new features, refactoring, unit tests, code documentation.

**Caution**: It is not going to support old versions anymore.


## [v0.0.3](https://github.com/strongqa/howitzer/compare/v0.0.1...v0.0.3)

### New Features

* Added supporting poltergeist driver

### Bugfixes

* Fixed problem with dependencies

## [v0.0.1](https://github.com/strongqa/howitzer/tree/v0.0.1)

Initial version
