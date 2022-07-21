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
          { source: 'drivers/browserstack.rb', destination: 'config/drivers/browserstack.rb' },
          { source: 'drivers/crossbrowsertesting.rb', destination: 'config/drivers/crossbrowsertesting.rb' },
          { source: 'drivers/headless_chrome.rb', destination: 'config/drivers/headless_chrome.rb' },
          { source: 'drivers/headless_firefox.rb', destination: 'config/drivers/headless_firefox.rb' },
          { source: 'drivers/lambdatest.rb', destination: 'config/drivers/lambdatest.rb' },
          { source: 'drivers/sauce.rb', destination: 'config/drivers/sauce.rb' },
          { source: 'drivers/selenium.rb', destination: 'config/drivers/selenium.rb' },
          { source: 'drivers/selenium_grid.rb', destination: 'config/drivers/selenium_grid.rb' },
          { source: 'drivers/testingbot.rb', destination: 'config/drivers/testingbot.rb' }
        ] }
    end

    protected

    def banner
      <<-MSG
  * Config files generation ...
      MSG
    end
  end
end
