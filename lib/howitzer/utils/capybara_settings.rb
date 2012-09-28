module CapybaraSettings
  extend self

  def self.base_ff_profile_settings
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["network.http.phishy-userpass-length"] = 255
    profile["browser.safebrowsing.malware.enabled"] = false
    profile["network.automatic-ntlm-auth.allow-non-fqdn"] = true
    profile["network.ntlm.send-lm-response"] = true
    profile["network.automatic-ntlm-auth.trusted-uris"] = settings.app_main_host
    profile
  end

  Capybara.run_server = false
  Capybara.app_host = ''
  Capybara.default_wait_time = settings.timeout_small
  Capybara.ignore_hidden_elements = true
  case settings.driver.to_sym
    when :selenium
      Capybara.register_driver :selenium do |app|
        params = {browser: settings.sel_browser.to_sym}
        params[:profile] = base_ff_profile_settings if ff_browser?
        Capybara::Selenium::Driver.new app, params
      end
    when :selenium_dev
      Capybara.register_driver :selenium_dev do |app|
        profile = base_ff_profile_settings
        fb_name = "firebug-#{settings.sel_firebug_version}-fx.xpi"
        fp_name = "firepath-#{settings.sel_firepath_version}.xpi"
        [fb_name, fp_name].each do |name|
          profile.add_extension(File.expand_path(name, File.join('shared', 'vendor', 'firebug')))
        end
        profile['extensions.firebug.currentVersion']    = settings.sel_firebug_version # avoid 'first run' tab
        profile["extensions.firebug.previousPlacement"] = 1
        profile["extensions.firebug.onByDefault"]       = true
        profile["extensions.firebug.defaultPanelName"]  = "firepath"
        profile["extensions.firebug.script.enableSites"] = true
        profile["extensions.firebug.net.enableSites"] = true
        profile["extensions.firebug.console.enableSites"] = true

        Capybara::Selenium::Driver.new app, browser: :firefox, profile: profile
      end
    when :webkit
      require 'capybara-webkit'
    when :poltergeist
      require 'capybara/poltergeist'
    when :sauce
      caps_opts = {
          platform: settings.sl_platform,
          browser_name: settings.sl_browser_name,
          name: 'Capybara test name should be overwritten',
          "max-duration" => settings.sl_max_duration,
          'idle-timeout' => settings.sl_idle_timeout,
          'selenium-version' => settings.sl_selenium_version,
          'record-screenshots' => settings.sl_record_screenshot,
          'video-upload-on-pass' => settings.sl_video_upload_on_pass
      }

      unless (settings.sl_browser_version.to_s || "").empty?
        caps_opts['browser-version'] = settings.sl_browser_version.to_s
      end

      options = {
          url: settings.sl_url,
          desired_capabilities: Selenium::WebDriver::Remote::Capabilities.new(caps_opts),
          http_client: Selenium::WebDriver::Remote::Http::Default.new.tap{|c| c.timeout = settings.timeout_medium},
          browser: :remote
      }

      Capybara.register_driver :sauce do |app|
        Capybara::Selenium::Driver.new(app, options)
      end

    else
      log.error "Unknown '#{settings.driver}' driver. Check your settings, it should be one of [selenium, selenium_dev, webkit, sauce]"
  end

  Capybara.default_driver = settings.driver.to_sym
  Capybara.javascript_driver = settings.driver.to_sym

  def sauce_resource_path(name)
    host = "https://#{settings.sl_user}:#{settings.sl_api_key}@saucelabs.com"
    path = "/rest/#{settings.sl_user}/jobs/#{session_id}/results/#{name}"
    "#{host}#{path}"
  end

  def update_sauce_job_status(json_data = {})
    host = "http://#{settings.sl_user}:#{settings.sl_api_key}@saucelabs.com"
    path = "/rest/v1/#{settings.sl_user}/jobs/#{session_id}"
    url = "#{host}#{path}"
    RestClient.put url, json_data.to_json, content_type: :json, accept: :json
  end

  def suite_name
    res = if ENV['RAKE_TASK']
      res = ENV['RAKE_TASK'].sub(/(?:r?spec|cucumber):?(.*)/, '\1').upcase
      res.empty? ? 'ALL' : res
    else
      'CUSTOM'
    end
    "#{res} #{settings.sl_browser_name.upcase}"
  end

  def session_id
    Capybara.current_session.driver.browser.instance_variable_get(:@bridge).session_id
  end

end

