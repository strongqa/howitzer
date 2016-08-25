<p align="center">
  <a href="https://github.com/strongqa/howitzer">
    <img src="https://github.com/strongqa/howitzer/blob/gh-pages/images/howitzer-logo.png" alt="Howitzer" />
  </a>
  <br/>
  
  <p align="center"><b>Ruby-based framework for acceptance testing of web applications.</b></p>
  
  <p align="center">It was originally developed for testing web applications, but you can also use it for API testing and web service testing. The framework was built with modern patterns, techniques, and tools in automated testing. </p>

  <p align="center">
  <a href="https://gitter.im/strongqa/howitzer"><img src="https://badges.gitter.im/Join%20Chat.svg" /></a>
  <a href="https://rubygems.org/gems/howitzer"><img src="http://img.shields.io/gem/v/her.svg" /></a>
  <a href="https://travis-ci.org/strongqa/howitzer"><img src="https://travis-ci.org/strongqa/howitzer.svg?branch=master" /></a>
  <a href='https://gemnasium.com/strongqa/howitzer'><img src="https://gemnasium.com/strongqa/howitzer.svg" /></a>
  <a href="https://codeclimate.com/github/strongqa/howitzer"><img src="https://codeclimate.com/github/strongqa/howitzer.png" /></a>
  <a href="https://coveralls.io/r/strongqa/howitzer?branch=master"><img src="https://coveralls.io/repos/strongqa/howitzer/badge.png?branch=master" /></a>
  <a href="https://github.com/strongqa/howitzer/blob/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg" /></a>
  </p>
  
</p>

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
* [Howitzer Example RSpec](https://github.com/strongqa/howitzer_example_rspec) – an example of Howitzer based project for demo web application based on RSpec.
* [Howitzer Example Cucumber](https://github.com/strongqa/howitzer_example_cucumber) – an example of Howitzer based project for demo web application based on Cucumber.
* [Howitzer Example Turnip](https://github.com/strongqa/howitzer_example_turnip) – an example of Howitzer based project for demo web application based on Turnip.
* [Howitzer Stat](https://github.com/strongqa/howitzer_stat) – is the extension to Howitzer product. It is used for automated tests coverage visualization of web pages.

## Requirements
* Supported OS: Mac OS X, Linux, Windows
* [Ruby](https://www.ruby-lang.org/en/downloads/) 2.2.2+
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
web/
  pages/
    example_page.rb
  sections/  
    menu_section.rb
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
            Identical 'config/boot.rb' file
            Identical 'config/custom.yml' file
            Added 'config/default.yml' file
        * Root files generation ...
            Added '.gitignore' file
            Conflict with 'Gemfile' file
              Overwrite 'Gemfile' file? [Yn]:Y
                Forced 'Gemfile' file
            Identical 'Rakefile' file
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
