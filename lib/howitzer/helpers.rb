require 'howitzer/exceptions'

module Howitzer
  # This module holds helpers methods
  module Helpers
    CHECK_YOUR_SETTINGS_MSG = 'Please check your settings'.freeze

    # rubocop:disable Style/ModuleFunction
    extend self

    ##
    #
    # Returns whether or not the current driver is SauceLabs.
    #

    def sauce_driver?
      log.error DriverNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if settings.driver.nil?
      settings.driver.to_s.to_sym == :sauce
    end

    ##
    #
    # Returns whether or not the current driver is TestingBot.
    #

    def testingbot_driver?
      log.error DriverNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if settings.driver.nil?
      settings.driver.to_s.to_sym == :testingbot
    end

    ##
    #
    # Returns whether or not the current driver is Selenium.
    #

    def selenium_driver?
      log.error DriverNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if settings.driver.nil?
      settings.driver.to_s.to_sym == :selenium
    end

    ##
    #
    # Returns whether or not the current driver is Selenium Grid.
    #

    def selenium_grid_driver?
      log.error DriverNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if settings.driver.nil?
      settings.driver.to_s.to_sym == :selenium_grid
    end

    ##
    #
    # Returns whether or not the current driver is PhantomJS.
    #

    def phantomjs_driver?
      log.error DriverNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if settings.driver.nil?
      settings.driver.to_s.to_sym == :phantomjs
    end

    ##
    #
    # Returns whether or not the current browser is Internet Explorer.
    #

    def ie_browser?
      browser? :ie, :iexplore
    end

    ##
    #
    # Returns whether or not the current browser is FireFox.
    #

    def ff_browser?
      browser? :ff, :firefox
    end

    ##
    #
    # Returns whether or not the current browser is Google Chrome.
    #

    def chrome_browser?
      browser? :chrome
    end

    ##
    #
    # Returns whether or not the current browser is Safari.
    #

    def safari_browser?
      browser? :safari
    end

    ##
    #
    # Returns application url including base authentication (if specified in settings)
    #

    def app_url
      prefix =
        if settings.app_base_auth_login.blank?
          ''
        else
          "#{settings.app_base_auth_login}:#{settings.app_base_auth_pass}@"
        end
      app_base_url prefix
    end

    ##
    #
    # Returns application url without base authentication by default
    #
    # *Parameters:*
    # * +prefix+ - Sets base authentication prefix (defaults to: nil)
    #

    def app_base_url(prefix = nil)
      "#{settings.app_protocol || 'http'}://#{prefix}#{settings.app_host}"
    end

    ##
    #
    # Returns formatted duration time
    #
    # *Parameters:*
    # * +time_in_numeric+ - Number of seconds
    #

    def duration(time_in_numeric)
      secs = time_in_numeric.to_i
      mins = secs / 60
      hours = mins / 60
      if hours > 0
        "[#{hours}h #{mins % 60}m #{secs % 60}s]"
      elsif mins > 0
        "[#{mins}m #{secs % 60}s]"
      elsif secs >= 0
        "[0m #{secs}s]"
      end
    end

    ##
    #
    # Evaluates given value
    #
    # *Parameters:*
    # * +value+ - Value to be evaluated
    #

    def ri(value)
      raise value.inspect
    end

    private

    def browser?(*browser_aliases)
      if sauce_driver?
        sauce_browser?(*browser_aliases)
      elsif testingbot_driver?
        testingbot_browser?(*browser_aliases)
      elsif selenium_driver? || selenium_grid_driver?
        selenium_browser?(*browser_aliases)
      end
    end

    def sauce_browser?(*browser_aliases)
      log.error SlBrowserNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if settings.sl_browser_name.nil?
      browser_aliases.include?(settings.sl_browser_name.to_s.to_sym)
    end

    def testingbot_browser?(*browser_aliases)
      log.error TbBrowserNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if settings.tb_browser_name.nil?
      browser_aliases.include?(settings.tb_browser_name.to_s.to_sym)
    end

    def selenium_browser?(*browser_aliases)
      log.error SelBrowserNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if settings.sel_browser.nil?
      browser_aliases.include?(settings.sel_browser.to_s.to_sym)
    end
  end
end
