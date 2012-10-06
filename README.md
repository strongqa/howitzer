# Howitzer

Howitzer is Ruby based framework for acceptance testing. 

Initially it was developed for testing of web applications, but it is applicable to testing of web services or some API as well.
The framework uses modern patterns, techniques and tools in automated testing area. For details, please see [Test Framework Design](https://github.com/romikoops/howitzer/wiki/Test-Framework-Design).

## Key benefits
- Independent of test web application, its technologies and lanquage.
- Deploy all test infrastructure for 5 minutes.
- Flexible test framework configuration.
- Ability to choose desired BDD tool (Cucumber for now only, but RSpec is coming soon)
- Itegration with SauceLabs, Mailgun web services.
- Easy to support tests in actual state.
- Ability to execute tests against to both browserless driver and actual browsers with no changes in your tests.

## Setup
To install, type

```bash
sudo gem install howitzer
```

## Usage
to deploy the framework, type:

```bash
mkdir test_automation
cd test_automation
howitzer install --cucumber
```

This command will generate next folders and files:
```
config/
        cucumber.yml
        default.yml
        custom.yml
tasks/
        cucumber.rake
emails/
        example_email.rb
features/
        support/env.rb
        step_definitions/common_steps.rb
        example.feature
pages/
        example_page.rb
        example_menu.rb
Gemfile
Rakefile
.gitignore
```
### Configuration
Learn and specify correct default settings in `config/default.yml` file. For details, please see original [sexy_settings](https://github.com/romikoops/sexy_settings) gem for details.

## Test implementation workflow

- Prepare some feature with scenarios in `features/some.feature` file.
- Implement step definitions in `features/step_definitions/common_steps.rb` file.
- Implement appropriate pages in `pages` folder. For details, see [Page Object Pattern](https://github.com/romikoops/howitzer/wiki/PageObject-pattern).
- Debug feature.
- Enjoy it!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
