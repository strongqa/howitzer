require 'rest-client'
require 'howitzer/exceptions'

module Howitzer
  # This module holds capybara helpers methods
  module CapybaraHelpers
    CHECK_YOUR_SETTINGS_MSG = 'Please check your settings'.freeze

    # @return [Boolean] true if current driver related with SauceLab,
    #   Testingbot or Browserstack cloud service

    def cloud_driver?
      [:sauce, :testingbot, :browserstack].include?(Howitzer.driver.to_sym)
    end

    # @return [Boolean] whether or not current browser is
    #   Internet Explorer.

    def ie_browser?
      browser? :ie, :iexplore
    end

    # @return [Boolean] whether or not current browser is FireFox.

    def ff_browser?
      browser? :ff, :firefox
    end

    # @return [Boolean] whether or not current browser is Google Chrome.

    def chrome_browser?
      browser? :chrome
    end

    # @return [Boolean] whether or not current browser is Safari.
    #

    def safari_browser?
      browser? :safari
    end

    # @param time_in_numeric [Integer] Number of seconds
    # @return [String] formatted duration time

    def duration(time_in_numeric)
      secs = time_in_numeric.to_i
      mins = secs / 60
      hours = mins / 60
      return "[#{hours}h #{mins % 60}m #{secs % 60}s]" if hours.positive?
      return "[#{mins}m #{secs % 60}s]" if mins.positive?
      return "[0m #{secs}s]" if secs >= 0
    end

    # Updates job status on job cloud
    # @note SauceLabs is currently supported only
    # @param json_data [String] (for example, {passed: true})

    def update_cloud_job_status(json_data = {})
      case Howitzer.driver.to_sym
      when :sauce then update_sauce_job_status(json_data)
      else
        '[NOT IMPLEMENTED]'
      end
    end

    # Tries to load appropriate driver gem
    # @param driver [String] driver name
    # @param lib [String] what is required to load
    # @param gem [String] gem name
    # @raise LoadError if gem is missing in bunder context

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
      http_client.timeout = Howitzer.cloud_http_idle_timeout

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
    # @note SauceLabs is supported currently only

    def cloud_resource_path(kind)
      case Howitzer.driver.to_sym
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
      Howitzer::Log.error CloudBrowserNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if Howitzer.cloud_browser_name.nil?
      browser_aliases.include?(Howitzer.cloud_browser_name.to_s.to_sym)
    end

    def selenium_browser?(*browser_aliases)
      Howitzer::Log.error SelBrowserNotSpecifiedError, CHECK_YOUR_SETTINGS_MSG if Howitzer.selenium_browser.nil?
      browser_aliases.include?(Howitzer.selenium_browser.to_s.to_sym)
    end

    def selenium_driver?
      Howitzer.driver.to_sym == :selenium
    end

    def selenium_grid_driver?
      Howitzer.driver.to_sym == :selenium_grid
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
