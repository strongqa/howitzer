<p align="center" style="overflow: hidden;">
  <a href="http://howitzer-framework.io">
    <img src="https://raw.githubusercontent.com/strongqa/howitzer/gh-pages/images/howitzer-logo.png" alt="Howitzer" />
  </a>
  <br/>

  <p align="center"><b>Ruby-based framework for acceptance testing of web applications.</b></p>

  <p align="center">The framework was built with modern patterns, techniques, and tools in automated testing in order to speed up tests development and simplify supporting.</p>

  <p align="center">
  <a href="https://gitter.im/strongqa/howitzer"><img src="https://badges.gitter.im/Join%20Chat.svg" /></a>
  <a href="https://rubygems.org/gems/howitzer"><img src="http://img.shields.io/gem/v/howitzer.svg" /></a>
  <a href="https://travis-ci.org/strongqa/howitzer"><img src="https://travis-ci.org/strongqa/howitzer.svg?branch=master" /></a>
  <a href="https://codeclimate.com/github/strongqa/howitzer"><img src="https://codeclimate.com/github/strongqa/howitzer.png" /></a>
  <a href='https://coveralls.io/github/strongqa/howitzer?branch=master'><img src='https://coveralls.io/repos/github/strongqa/howitzer/badge.svg?branch=master' alt='Coverage Status' /></a>
  <a href="https://github.com/strongqa/howitzer/blob/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg" /></a>
  </p>

</p>

## Key Benefits
- Independent of a web application technical stack, language and architecture.
- Fast installation and configuration of the complete testing infrastructure (takes less than 5 minutes).
- Elegant, intuitive and powerful Ruby language underneath.
- Possibility to choose your favorite BDD tool (Cucumber, RSpec or Turnip).
- Integration with SauceLabs, Testingbot, BrowserStack, CrossBrowserTesting cloud services.
- Integration with MailGun, Gmail, Mailtrap email services.
- Easy tests support based on the best patterns, techniques, principles.
- Ability to execute tests against to both browserless driver and actual browsers with no changes in your tests.

## Documentation
Refer to the [GETTING STARTED](http://docs.howitzer-framework.io) document to start working with *Howitzer*.

You can also find the Rdoc documentation on [Rubygems](https://rubygems.org/gems/howitzer).

## Related Products
* [Howitzer Example RSpec](https://github.com/strongqa/howitzer_example_rspec) – an example of Howitzer based project for demo web application based on RSpec.
* [Howitzer Example Cucumber](https://github.com/strongqa/howitzer_example_cucumber) – an example of Howitzer based project for demo web application based on Cucumber.
* [Howitzer Example Turnip](https://github.com/strongqa/howitzer_example_turnip) – an example of Howitzer based project for demo web application based on Turnip.

## Requirements
* Supported OS: Mac OS X, Linux, Windows
* [Ruby](https://www.ruby-lang.org/en/downloads/) 2.3+
* [DevKit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit#installation-instructions) (For **Windows** only)
* [PhantomJS](http://phantomjs.org/download.html) (For **poltergeist** driver only)
* [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/) (For **chrome** selenium browser, 2.29+ for headless mode)
* [GeckoDriver](https://github.com/mozilla/geckodriver/releases) (For **firefox** selenium browser)
* [SafariDriver](https://webkit.org/blog/6900/webdriver-support-in-safari-10/) (For **safari** selenium browser)
* [QT](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit) (For **webkit** driver only)
* [Chrome](https://www.google.com/chrome/browser/desktop/index.html) v.59+ (For **headless chrome** support)
* [Firefox](https://www.mozilla.org/en-US/firefox/new/) v.56+ (For **headless firefox** support)
* [Android SDK](https://developer.android.com/studio/index.html) and [Appium](http://appium.io/getting-started.html) (For Appium driver)
## Setup
To install, type

```bash
gem install howitzer
```

## Usage
Browse to a desired directory where a new project will be created.

To generate the project with [Cucumber](https://cucumber.io/), type:

```bash
howitzer new <PROJECT NAME> --cucumber
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

- Prepare BDD feature with scenarios
- Mark feature/scenarios with priority tags.
- Implement prerequisites generation (optional):
  * implement factories
  * implement models
- Implement appropriate pages in the `web/pages` folder. For details, refer to  [Page Object Pattern](https://github.com/strongqa/howitzer/wiki/PageObject-pattern).
- Implement emails in `emails` folder (optional).
- Implement scenarios:
  * For Cucumber:
    1. Read and learn [Cucumber Best Practices](https://github.com/strongqa/howitzer/wiki/Cucumber-Best-Practices)
    2. Implement step definitions in the `features/step_definitions` folder.
  * For Rspec: Use [DSL](https://github.com/jnicklas/capybara/blob/master/lib/capybara/rspec/features.rb) provided by Capybara to create descriptive acceptance tests.
  * For Turnip: Implement step definitions in the `spec/steps` folder.
- Debug features against to desired drivers.
- Enjoy it!

## Rake Tasks

[Rake](https://ruby.github.io/rake/) was originally created to handle software build processes, but the combination of convenience and flexibility that it provides has made it the standard method of job automation for Ruby projects.

You can get a list of all available tasks by typing the following command:

```bash
rake -T

```

## Upgrading Howitzer
Before attempting to upgrade an existing project, you should be sure you have a good reason to upgrade. You need to balance several factors: the need for new features, the increasing difficulty of finding support for old code, and your available time and skills, to name a few.

From version _v1.1.0_ howitzer provides **howitzer update** command. After updating the Howitzer version in the Gemfile, run following commands:

```
bundle update howitzer
bundle exec howitzer update
```

This will help you with the creation of new files and changes of old files in an interactive session.

Don't forget to review the difference, to see if there were any unexpected changes and merge them. It is easy if your project is under revision control systems like _Git_.

## Additional Information
* [Rubygems](https://rubygems.org/gems/howitzer)
* [Mailing list](https://groups.google.com/forum/#!forum/howitzer_ruby)
* [Issues](https://github.com/strongqa/howitzer/issues)
* [Developer chat](https://gitter.im/strongqa/howitzer)

Contributing
------------

[![](https://sourcerer.io/fame/romikoops/strongqa/howitzer/images/0)](https://sourcerer.io/fame/romikoops/strongqa/howitzer/links/0)[![](https://sourcerer.io/fame/romikoops/strongqa/howitzer/images/1)](https://sourcerer.io/fame/romikoops/strongqa/howitzer/links/1)[![](https://sourcerer.io/fame/romikoops/strongqa/howitzer/images/2)](https://sourcerer.io/fame/romikoops/strongqa/howitzer/links/2)[![](https://sourcerer.io/fame/romikoops/strongqa/howitzer/images/3)](https://sourcerer.io/fame/romikoops/strongqa/howitzer/links/3)[![](https://sourcerer.io/fame/romikoops/strongqa/howitzer/images/4)](https://sourcerer.io/fame/romikoops/strongqa/howitzer/links/4)[![](https://sourcerer.io/fame/romikoops/strongqa/howitzer/images/5)](https://sourcerer.io/fame/romikoops/strongqa/howitzer/links/5)[![](https://sourcerer.io/fame/romikoops/strongqa/howitzer/images/6)](https://sourcerer.io/fame/romikoops/strongqa/howitzer/links/6)[![](https://sourcerer.io/fame/romikoops/strongqa/howitzer/images/7)](https://sourcerer.io/fame/romikoops/strongqa/howitzer/links/7)

Please see [CONTRIBUTING.md](CONTRIBUTING.md).

howitzer was originally designed by Roman Parashchenko and is now maintained by StrongQA team. You can find list of contributors here [open source
community](https://github.com/strongqa/howitzer/graphs/contributors).

License
-------

howitzer is Copyright © 2012-2017 Roman Parashchenko and StrongQA Ltd. It is free
software, and may be redistributed under the terms specified in the
[LICENSE](LICENSE) file.

About StrongQA
----------------

![StrongQA](https://github.com/strongqa/howitzer/blob/gh-pages/images/strongqa-logo.png)

howitzer is maintained and funded by StrongQA, Ltd.
The names and logos for StrongQA are trademarks of StrongQA, Ltd.

We love open source software!
See [our other projects][testing_solutions] or [hire us][hire] to consult and develop testing solutions.

[testing_solutions]: http://strongqa.com/testing_solutions/?utm_source=github
[hire]: https://strongqa.com?utm_source=github
