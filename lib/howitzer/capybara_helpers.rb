require 'rest-client'
require 'howitzer/exceptions'

module Howitzer
  # This module holds capybara helpers methods
  module CapybaraHelpers
    CHECK_YOUR_SETTINGS_MSG = 'Please check your settings'.freeze #:nodoc:
    HOWITZER_KNOWN_BROWSERS = [ #:nodoc:
      CLOUD_BROWSERS = [
        SAUCE = :sauce,
        TESTINGBOT = :testingbot,
        BROWSERSTACK = :browserstack,
        CROSSBROWSERTESTING = :crossbrowsertesting
      ].freeze,
      LOCAL_BROWSERS = [
        HEADLESS_CHROME = :headless_chrome,
        POLTERGEIST = :poltergeist,
        SELENIUM = :selenium,
        SELENIUM_GRID = :selenium_grid,
        WEBKIT = :webkit
      ].freeze
    ].freeze

    # @return [Boolean] true if current driver related with SauceLab,
    #   Testingbot or Browserstack cloud service

    def cloud_driver?
      CLOUD_BROWSERS.include?(Howitzer.driver.to_sym)
    end

    # @return [Boolean] whether or not current browser is
    #   Internet Explorer.
    # @raise [CloudBrowserNotSpecifiedError] if cloud driver and missing browser name
    # @raise [SelBrowserNotSpecifiedError] if selenium driver and missing browser name

    def ie_browser?
      browser? :ie, :iexplore
    end

    # @return [Boolean] whether or not current browser is FireFox.
    # @raise [CloudBrowserNotSpecifiedError] if cloud driver and missing browser name
    # @raise [SelBrowserNotSpecifiedError] if selenium driver and missing browser name

    def ff_browser?
      browser? :ff, :firefox
    end

    # @return [Boolean] whether or not current browser is Google Chrome.
    # @raise [CloudBrowserNotSpecifiedError] if cloud driver and missing browser name
    # @raise [SelBrowserNotSpecifiedError] if selenium driver and missing browser name

    def chrome_browser?
      browser?(:chrome) || Howitzer.driver == HEADLESS_CHROME.to_s
    end

    # @return [Boolean] whether or not current browser is Safari.
    # @raise [CloudBrowserNotSpecifiedError] if cloud driver and missing browser name
    # @raise [SelBrowserNotSpecifiedError] if selenium driver and missing browser name

    def safari_browser?
      browser? :safari
    end

    # @param time_in_numeric [Integer] number of seconds
    # @return [String] formatted duration time

    def duration(time_in_numeric)
      secs = time_in_numeric.to_i
      mins = secs / 60
      hours = mins / 60
      return "[#{hours}h #{mins % 60}m #{secs % 60}s]" if hours.positive?
      return "[#{mins}m #{secs % 60}s]" if mins.positive?
      return "[0m #{secs}s]" if secs >= 0
    end

    # Updates a job status on the job cloud
    # @note SauceLabs is currently supported only
    # @param json_data [Hash] for example, (passed: true)

    def update_cloud_job_status(json_data = {})
      case Howitzer.driver.to_sym
      when SAUCE then update_sauce_job_status(json_data)
      else
        '[NOT IMPLEMENTED]'
      end
    end

    # Tries to load appropriate driver gem
    # @param driver [String] a driver name
    # @param lib [String] what is required to load
    # @param gem [String] a gem name
    # @raise [LoadError] if the gem is missing in a bunder context

    def load_driver_gem!(driver, lib, gem)
      require lib
    rescue LoadError
      raise LoadError,
            "`:#{driver}` driver is unable to load `#{lib}`, please add `gem '#{gem}'` to your Gemfile."
    end

    # @return [Hash] selenium capabilities required for a cloud driver

    def required_cloud_caps
      {
        platform: Howitzer.cloud_platform,
        browserName: Howitzer.cloud_browser_name,
        version: Howitzer.cloud_browser_version,
        name: "#{prefix_name} #{Howitzer.cloud_browser_name}"
      }
    end

    # Buids selenium driver for a cloud service
    # @param app [<Rack>] a rack application that this server will contain
    # @param caps [Hash] remote capabilities
    # @param url [String] a remote hub url
    # @return [Capybara::Selenium::Driver]

    def cloud_driver(app, caps, url)
      http_client = ::Selenium::WebDriver::Remote::Http::Default.new
      http_client.read_timeout = Howitzer.cloud_http_idle_timeout
      http_client.open_timeout = Howitzer.cloud_http_idle_timeout

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

    # @return [String] path to cloud resources (logs, videos, etc.)
    # @note Currently SauceLabs is supported only
    # @raise [ArgumentError] if unknown kind

    def cloud_resource_path(kind)
      case Howitzer.driver.to_sym
      when SAUCE then sauce_resource_path(kind)
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
      unless Howitzer.cloud_browser_name.nil?
        return browser_aliases.include?(Howitzer.cloud_browser_name.to_s.downcase.to_sym)
      end
      raise Howitzer::CloudBrowserNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG
    end

    def selenium_browser?(*browser_aliases)
      return browser_aliases.include?(Howitzer.selenium_browser.to_s.to_sym) unless Howitzer.selenium_browser.nil?
      raise Howitzer::SelBrowserNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG
    end

    def selenium_driver?
      Howitzer.driver.to_sym == SELENIUM
    end

    def selenium_grid_driver?
      Howitzer.driver.to_sym == SELENIUM_GRID
    end

    def prefix_name
      (Howitzer.current_rake_task || 'ALL').upcase
    end

    def sauce_resource_path(kind)
      name =
        case kind
        when :video then 'video.flv'
        when :server_log then 'selenium-server.log'
        else
          raise ArgumentError, "Unknown '#{kind}' kind"
        end
      host = "https://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@saucelabs.com"
      path = "/rest/#{Howitzer.cloud_auth_login}/jobs/#{session_id}/results/#{name}"
      "#{host}#{path}"
    end

    def update_sauce_job_status(json_data = {})
      host = "http://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@saucelabs.com"
      path = "/rest/v1/#{Howitzer.cloud_auth_login}/jobs/#{session_id}"
      url = "#{host}#{path}"
      ::RestClient.put url, json_data.to_json, content_type: :json, accept: :json
    end

    def session_id
      Capybara.current_session.driver.browser.instance_variable_get(:@bridge).session_id
    end

    def remote_file_detector
      lambda do |args|
        str = args.first.to_s
        str if File.exist?(str)
      end
    end
  end
end
