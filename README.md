# Howitzer

TODO: Write a gem description

## Installation
Install it yourself as:

    $ gem install howitzer

## Usage

Write command in command line:

    $ howitzer install --cucumber

### This command will generate next folders and files:
```
config/
        cucumber.yml
        default.yml
        custom.yml
tasks/
        cucumber.rake
email/
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
