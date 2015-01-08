##
#
# Predefined Capybara settings and capybara drivers
#
require 'selenium-webdriver'
require 'capybara'
require 'howitzer/utils/log'
module Capybara
  module Settings
    extend self

    ##
    #
    # Predefined settings of Firefox browser
    #
    # *Returns:*
    # * +Hash+ - Settings that can be changed
    #


    def self.base_ff_profile_settings
      profile = ::Selenium::WebDriver::Firefox::Profile.new
      profile["network.http.phishy-userpass-length"] = 255
      profile["browser.safebrowsing.malware.enabled"] = false
      profile["network.automatic-ntlm-auth.allow-non-fqdn"] = true
      profile["network.ntlm.send-lm-response"] = true
      profile["network.automatic-ntlm-auth.trusted-uris"] = settings.app_host
      profile
    end

    class << self

      ##
      #
      #Defines driver based on specified test environment settings
      #

      def define_driver
        case settings.driver.to_sym
          when :selenium
            define_selenium_driver
          when :selenium_dev
            define_selenium_dev_driver
          when :webkit
            define_webkit_driver
          when :poltergeist
            define_poltergeist_driver
          when :phantomjs
            define_phantomjs_driver
          when :sauce
            define_sauce_driver
          when :testingbot
            define_testingbot_driver
          when :browserstack
            define_browserstack_driver
          else
            log.error "Unknown '#{settings.driver}' driver. Check your settings, it should be one of [selenium, selenium_dev, webkit, poltergeist, phantomjs, sauce, testingbot]"
        end
      end

      private

      def define_selenium_driver
        Capybara.register_driver :selenium do |app|
          params = {browser: settings.sel_browser.to_sym}
          params[:profile] = base_ff_profile_settings if ff_browser?
          Capybara::Selenium::Driver.new app, params
        end
      end

      def define_selenium_dev_driver
        Capybara.register_driver :selenium_dev do |app|
          profile = base_ff_profile_settings
          vendor_dir = settings.custom_vendor_dir || File.join(File.dirname(__FILE__), '..', 'vendor')
          log.error "Vendor directory was not found('#{vendor_dir}')." unless Dir.exist?(vendor_dir)
          %w(firebug*.xpi firepath*.xpi).each do |file_name|
            full_path_pattern = File.join(File.expand_path(vendor_dir), file_name)
            if (full_path = Dir[full_path_pattern].first)
              profile.add_extension full_path
            else
              log.error "Extension was not found by '#{full_path_pattern}' pattern!"
            end
          end
          profile['extensions.firebug.currentVersion']    = 'Last' # avoid 'first run' tab
          profile["extensions.firebug.previousPlacement"] = 1
          profile["extensions.firebug.onByDefault"]       = true
          profile["extensions.firebug.defaultPanelName"]  = "firepath"
          profile["extensions.firebug.script.enableSites"] = true
          profile["extensions.firebug.net.enableSites"] = true
          profile["extensions.firebug.console.enableSites"] = true

          Capybara::Selenium::Driver.new app, browser: :firefox, profile: profile
        end
      end

      def define_webkit_driver
        require 'capybara-webkit'
      end

      def define_poltergeist_driver
        require 'capybara/poltergeist'
        Capybara.register_driver :poltergeist do |app|
          Capybara::Poltergeist::Driver.new(
              app, {
              js_errors: !settings.pjs_ignore_js_errors,
              phantomjs_options: ["--ignore-ssl-errors=#{settings.pjs_ignore_ssl_errors ? 'yes' : 'no'}" ]
          }
          )
        end
      end

      def define_phantomjs_driver
        Capybara.register_driver :phantomjs do |app|
          Capybara::Selenium::Driver.new(
            app, browser: :phantomjs,
                desired_capabilities: {
                    javascript_enabled: !settings.pjs_ignore_js_errors
                },
                args: ["--ignore-ssl-errors=#{settings.pjs_ignore_ssl_errors ? 'yes' : 'no'}" ]
          )
        end
      end

      def define_sauce_driver
        task_name = ENV['RAKE_TASK'].to_s.sub(/(?:r?spec|cucumber):?(.*)/, '\1').upcase
        caps_opts = {
            platform: settings.sl_platform,
            browser_name: settings.sl_browser_name,
            name: "#{ENV['RAKE_TASK'] ? (task_name.empty? ? 'ALL' : task_name) : 'CUSTOM'} #{settings.sl_browser_name.upcase}",
            "max-duration" => settings.sl_max_duration,
            'idle-timeout' => settings.sl_idle_timeout,
            'selenium-version' => settings.sl_selenium_version,
            'record-screenshots' => settings.sl_record_screenshot,
            'video-upload-on-pass' => settings.sl_video_upload_on_pass
        }

        unless (settings.sl_browser_version.to_s || "").empty?
          caps_opts['version'] = settings.sl_browser_version.to_s
        end

        options = {
            url: settings.sl_url,
            desired_capabilities: ::Selenium::WebDriver::Remote::Capabilities.new(caps_opts),
            http_client: ::Selenium::WebDriver::Remote::Http::Default.new.tap{|c| c.timeout = settings.timeout_medium},
            browser: :remote
        }

        Capybara.register_driver :sauce do |app|
          driver = Capybara::Selenium::Driver.new(app, options)
          driver.browser.file_detector = lambda do |args|
            str = args.first.to_s
            str if File.exist?(str)
          end
          driver
        end
      end

      def define_testingbot_driver
        require 'testingbot'
        task_name = ENV['RAKE_TASK'].to_s.sub(/(?:r?spec|cucumber):?(.*)/, '\1').upcase
        caps_opts = {
          platform: settings.tb_platform,
          browser_name: settings.tb_browser_name,
          name: "#{ENV['RAKE_TASK'] ? (task_name.empty? ? 'ALL' : task_name) : 'CUSTOM'} #{settings.tb_browser_name.upcase}",
          maxduration: settings.tb_max_duration.to_i,
          idletimeout: settings.tb_idle_timeout.to_i,
          'selenium-version' => settings.tb_selenium_version,
          screenshot: settings.tb_record_screenshot,
          'avoid-proxy' => settings.tb_avoid_proxy
        }

        unless (settings.tb_browser_version.to_s || "").empty?
                  caps_opts['version'] = settings.tb_browser_version.to_s
        end
        options = {
          url: settings.tb_url,
          desired_capabilities: ::Selenium::WebDriver::Remote::Capabilities.new(caps_opts),
          http_client: ::Selenium::WebDriver::Remote::Http::Default.new.tap{|c| c.timeout = settings.timeout_medium},
          browser: :remote
        }
        Capybara.register_driver :testingbot do |app|
          driver = Capybara::Selenium::Driver.new(app, options)
          driver.browser.file_detector = lambda do |args|
            str = args.first.to_s
            str if File.exist?(str)
          end
          driver
        end
      end
    end

    def define_browserstack_driver
      task_name = ENV['RAKE_TASK'].to_s.sub(/(?:r?spec|cucumber):?(.*)/, '\1').upcase
      caps_opts = {
          os: settings.bs_os_name,
          os_version: settings.bs_os_version,
          browser: settings.bs_browser_name,
          browser_version: settings.bs_browser_version,
          name: "#{ENV['RAKE_TASK'] ? (task_name.empty? ? 'ALL' : task_name) : 'CUSTOM'} #{settings.bs_browser_name.upcase}",
          maxduration: settings.bs_max_duration.to_i,
          idletimeout: settings.bs_idle_timeout.to_i,
          project: settings.bs_project,
          build: settings.bs_build,
          resolution: settings.bs_resolution,
          browserName: (settings.bs_m_browser if settings.bs_mobile ),
          platform: (settings.bs_m_platform if settings.bs_mobile ),
          device: (settings.bs_m_device if settings.bs_mobile )
      }
      options = {
          url: settings.bs_url,
          desired_capabilities: ::Selenium::WebDriver::Remote::Capabilities.new(caps_opts),
          browser: :remote
      }
      Capybara.register_driver :browserstack do |app|
        driver = Capybara::Selenium::Driver.new(app, options)
        driver.browser.file_detector = lambda do |args|
          str = args.first.to_s
          str if File.exist?(str)
        end

        driver
      end
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

    def sauce_resource_path(name)
      host = "https://#{settings.sl_user}:#{settings.sl_api_key}@saucelabs.com"
      path = "/rest/#{settings.sl_user}/jobs/#{session_id}/results/#{name}"
      "#{host}#{path}"
    end

    ##
    #
    # Sends http request to change current Sauce Labs job status - pass/fail
    #
    # *Parameters:*
    # * +json_data+ - test status as hash (for details see Saucelab documentation)
    #


    def update_sauce_job_status(json_data = {})
      host = "http://#{settings.sl_user}:#{settings.sl_api_key}@saucelabs.com"
      path = "/rest/v1/#{settings.sl_user}/jobs/#{session_id}"
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
      "#{res} #{settings.sl_browser_name.upcase}"
    end

    ##
    #
    # Returns current session id
    #

    def session_id
      Capybara.current_session.driver.browser.instance_variable_get(:@bridge).session_id
    end

    Capybara.run_server = false
    Capybara.app_host = ''
    Capybara.default_wait_time = settings.timeout_small
    Capybara.ignore_hidden_elements = true
    Capybara.visible_text_only = true
    Capybara.match = :one
    Capybara.exact_options = true
    Capybara.default_driver = settings.driver.to_sym
    Capybara.javascript_driver = settings.driver.to_sym

    define_driver

  end
end

# @deprecated
#
CapybaraSettings = Capybara::Settings