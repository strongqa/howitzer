require_relative '../base_generator'
module Howitzer
  # This class responsible for configuration files generation
  class ConfigGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: 'boot.rb', destination: 'config/boot.rb' },
          { source: 'custom.yml', destination: 'config/custom.yml' },
          { source: 'capybara.rb', destination: 'config/capybara.rb' },
          { source: 'default.yml', destination: 'config/default.yml' },
          { source: 'drivers/browserstack_driver.rb', destination: 'config/drivers/browserstack_driver.rb' },
          { source: 'drivers/crossbrowsertesting_driver.rb',
            destination: 'config/drivers/crossbrowsertesting_driver.rb' },
          { source: 'drivers/headless_chrome_driver.rb', destination: 'config/drivers/headless_chrome_driver.rb' },
          { source: 'drivers/phantomjs_driver.rb', destination: 'config/drivers/phantomjs_driver.rb' },
          { source: 'drivers/poltergeist_driver.rb', destination: 'config/drivers/poltergeist_driver.rb' },
          { source: 'drivers/sauce_driver.rb', destination: 'config/drivers/sauce_driver.rb' },
          { source: 'drivers/selenium_driver.rb', destination: 'config/drivers/selenium_driver.rb' },
          { source: 'drivers/selenium_grid_driver.rb', destination: 'config/drivers/selenium_grid_driver.rb' },
          { source: 'drivers/testingbot_driver.rb', destination: 'config/drivers/testingbot_driver.rb' },
          { source: 'drivers/webkit_driver.rb', destination: 'config/drivers/webkit_driver.rb' }
        ] }
    end

    protected

    def banner
      <<-EOF
  * Config files generation ...
      EOF
    end
  end
end
