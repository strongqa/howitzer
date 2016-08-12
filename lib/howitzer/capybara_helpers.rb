require 'rest-client'
require 'howitzer/exceptions'

module Howitzer
  # This module holds helpers methods
  module CapybaraHelpers
    CHECK_YOUR_SETTINGS_MSG = 'Please check your settings'.freeze

    # describe me!

    def cloud_driver?
      [:sauce, :testingbot, :browserstack].include?(settings.driver.to_sym)
    end

    ##
    #
    # Returns whether or not the current driver is Selenium.
    #

    def selenium_driver?
      settings.driver.to_sym == :selenium
    end

    ##
    #
    # Returns whether or not the current driver is Selenium Grid.
    #

    def selenium_grid_driver?
      settings.driver.to_sym == :selenium_grid
    end

    ##
    #
    # Returns whether or not the current driver is PhantomJS.
    #

    def phantomjs_driver?
      settings.driver.to_sym == :phantomjs
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
    # Returns formatted duration time
    #
    # *Parameters:*
    # * +time_in_numeric+ - Number of seconds
    #

    def duration(time_in_numeric)
      secs = time_in_numeric.to_i
      mins = secs / 60
      hours = mins / 60
      return "[#{hours}h #{mins % 60}m #{secs % 60}s]" if hours.positive?
      return "[#{mins}m #{secs % 60}s]" if mins.positive?
      return "[0m #{secs}s]" if secs >= 0
    end

    # describe me!
    def prefix_name
      (ENV['RAKE_TASK'] || 'ALL').upcase
    end

    ##
    #
    # Returns url of current Sauce Labs job
    #
    # *Parameters:*
    # * +name+ - Your account name
    #
    # *Returns:*
    # * +string+ - URL address of last running Sauce Labs job
    #

    def sauce_resource_path(kind)
      name =
        case kind
        when :video then 'video.flv'
        when :server_log then 'selenium-server.log'
        else
          raise ArgumentError, "Unknown '#{kind}' kind"
        end
      host = "https://#{settings.cloud_auth_login}:#{settings.cloud_auth_pass}@saucelabs.com"
      path = "/rest/#{settings.cloud_auth_login}/jobs/#{session_id}/results/#{name}"
      "#{host}#{path}"
    end

    def update_cloud_job_status(json_data = {})
      case settings.driver.to_sym
      when :sauce then update_sauce_job_status(json_data)
      else
        '[NOT IMPLEMENTED]'
      end
    end

    ##
    #
    # Sends http request to change current Sauce Labs job status - pass/fail
    #
    # *Parameters:*
    # * +json_data+ - test status as hash (for details see Saucelab documentation)
    #

    def update_sauce_job_status(json_data = {})
      host = "http://#{settings.cloud_auth_login}:#{settings.cloud_auth_pass}@saucelabs.com"
      path = "/rest/v1/#{settings.cloud_auth_login}/jobs/#{session_id}"
      url = "#{host}#{path}"
      ::RestClient.put url, json_data.to_json, content_type: :json, accept: :json
    end

    ##
    #
    # Returns custom name for Sauce Labs job
    #
    # *Returns:*
    # * +string+ - Return name of current Sauce Labs job
    #

    def suite_name
      res = if ENV['RAKE_TASK']
              res = ENV['RAKE_TASK'].sub(/(?:r?spec|cucumber):?(.*)/, '\1').upcase
              res.empty? ? 'ALL' : res
            else
              'CUSTOM'
            end
      "#{res} #{settings.cloud_browser_name.upcase}"
    end

    # describe me!
    def load_driver_gem!(driver, lib, gem)
      require lib
    rescue LoadError
      raise LoadError,
            "`:#{driver}` driver is unable to load `#{lib}`, please add `gem '#{gem}'` to your Gemfile."
    end

    ##
    #
    # Returns current session id
    #

    def session_id
      Capybara.current_session.driver.browser.instance_variable_get(:@bridge).session_id
    end

    # describe me!
    def required_cloud_caps
      {
        platform: settings.cloud_platform,
        browserName: settings.cloud_browser_name,
        version: settings.cloud_browser_version,
        name: "#{prefix_name} #{settings.cloud_browser_name}"
      }
    end

    # describe me!
    def remote_file_detector
      lambda do |args|
        str = args.first.to_s
        str if File.exist?(str)
      end
    end

    # describe me!
    def cloud_driver(app, caps, url)
      http_client = ::Selenium::WebDriver::Remote::Http::Default.new
      http_client.timeout = settings.cloud_http_idle_timeout

      options = {
        url: url,
        desired_capabilities: ::Selenium::WebDriver::Remote::Capabilities.new(caps),
        http_client: http_client,
        browser: :remote
      }
      driver = Capybara::Selenium::Driver.new(app, options)
      driver.browser.file_detector = remote_file_detector
      driver
    end

    # describe me!

    def cloud_resource_path(kind)
      case settings.driver.to_sym
      when :sauce then sauce_resource_path(kind)
      else
        '[NOT IMPLEMENTED]'
      end
    end

    private

    def browser?(*browser_aliases)
      return cloud_browser?(*browser_aliases) if cloud_driver?
      return selenium_browser?(*browser_aliases) if selenium_driver? || selenium_grid_driver?
    end

    def cloud_browser?(*browser_aliases)
      log.error CloudBrowserNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if settings.cloud_browser_name.nil?
      browser_aliases.include?(settings.cloud_browser_name.to_s.to_sym)
    end

    def selenium_browser?(*browser_aliases)
      log.error SelBrowserNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if settings.selenium_browser.nil?
      browser_aliases.include?(settings.selenium_browser.to_s.to_sym)
    end
  end
end
