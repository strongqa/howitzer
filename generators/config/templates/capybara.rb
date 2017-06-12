HOWITZER_KNOWN_DRIVERS = %i[
  selenium
  selenium_grid
  webkit
  poltergeist
  phantomjs
  sauce
  testingbot
  browserstack
  headless_chrome
].freeze

unless HOWITZER_KNOWN_DRIVERS.include?(Howitzer.driver.to_s.to_sym)
  raise Howitzer::UnknownDriverError, "Unknown '#{Howitzer.driver}' driver." \
                      " Check your settings, it should be one of #{HOWITZER_KNOWN_DRIVERS}"
end

Capybara.configure do |config|
  config.run_server = false
  config.app_host = nil
  config.asset_host = Howitzer.app_uri.origin
  config.default_selector = :css
  config.default_max_wait_time = Howitzer.capybara_wait_time
  config.ignore_hidden_elements = true
  config.match = :one
  config.exact = true
  config.visible_text_only = true
  config.default_driver = Howitzer.driver.to_s.to_sym
  config.javascript_driver = Howitzer.driver.to_s.to_sym
end

require 'howitzer/capybara_helpers'

# namespace for capybara helpers
module CapybaraHelpers
  extend Howitzer::CapybaraHelpers
end

# :selenium driver

Capybara.register_driver :selenium do |app|
  params = { browser: Howitzer.selenium_browser.to_s.to_sym }
  if CapybaraHelpers.ff_browser?
    ff_profile = Selenium::WebDriver::Firefox::Profile.new.tap do |profile|
      profile['network.http.phishy-userpass-length'] = 255
      profile['browser.safebrowsing.malware.enabled'] = false
      profile['network.automatic-ntlm-auth.allow-non-fqdn'] = true
      profile['network.ntlm.send-lm-response'] = true
      profile['network.automatic-ntlm-auth.trusted-uris'] = Howitzer.app_host
    end
    params[:profile] = ff_profile
  end
  Capybara::Selenium::Driver.new app, params
end

# :headless_chrome driver

Capybara.register_driver :headless_chrome do |app|
  startup_flags = ['--headless']
  startup_flags << '-start-maximized' if Howitzer.maximized_window
  startup_flags.concat(Howitzer.headless_chrome_flags.split(/\s*,\s*/)) if Howitzer.headless_chrome_flags
  params = { browser: :chrome, switches: startup_flags }
  Capybara::Selenium::Driver.new app, params
end

# :webkit driver

if Howitzer.driver.to_sym == :webkit
  CapybaraHelpers.load_driver_gem!(:webkit, 'capybara-webkit', 'capybara-webkit')
  Capybara::Webkit.configure do |config|
    config.allow_url(Howitzer.app_host)
  end
end

# :poltergeist driver

if Howitzer.driver.to_sym == :poltergeist
  CapybaraHelpers.load_driver_gem!(:poltergeist, 'capybara/poltergeist', 'poltergeist')

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      js_errors: !Howitzer.phantom_ignore_js_errors,
      phantomjs_options: ["--ignore-ssl-errors=#{Howitzer.phantom_ignore_ssl_errors ? 'yes' : 'no'}"]
    )
  end
end

# :phantomjs driver

Capybara.register_driver :phantomjs do |app|
  Capybara::Selenium::Driver.new(
    app, browser: :phantomjs,
         desired_capabilities: {
           javascript_enabled: !Howitzer.phantom_ignore_js_errors
         },
         driver_opts: {
           args: ["--ignore-ssl-errors=#{Howitzer.phantom_ignore_ssl_errors ? 'yes' : 'no'}"]
         }
  )
end

# :sauce driver

Capybara.register_driver :sauce do |app|
  caps = CapybaraHelpers.required_cloud_caps.merge(
    maxDuration: Howitzer.cloud_max_duration,
    idleTimeout: Howitzer.cloud_sauce_idle_timeout,
    recordScreenshots: Howitzer.cloud_sauce_record_screenshots,
    videoUploadOnPass: Howitzer.cloud_sauce_video_upload_on_pass
  )
  url = "http://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@ondemand.saucelabs.com:80/wd/hub"
  CapybaraHelpers.cloud_driver(app, caps, url)
end

# :testingbot driver

Capybara.register_driver :testingbot do |app|
  caps = CapybaraHelpers.required_cloud_caps.merge(
    maxduration: Howitzer.cloud_max_duration,
    idletimeout: Howitzer.cloud_testingbot_idle_timeout,
    screenshot: Howitzer.cloud_testingbot_screenshots
  )
  url = "http://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@hub.testingbot.com/wd/hub"
  CapybaraHelpers.cloud_driver(app, caps, url)
end

# :browserstack driver

Capybara.register_driver :browserstack do |app|
  caps = CapybaraHelpers.required_cloud_caps.merge(
    project: Howitzer.cloud_bstack_project,
    build: Howitzer.cloud_bstack_build
  )
  caps[:resolution] = Howitzer.cloud_bstack_resolution if Howitzer.cloud_bstack_resolution.present?
  caps[:device] = Howitzer.cloud_bstack_mobile_device if Howitzer.cloud_bstack_mobile_device.present?
  url = "http://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@hub.browserstack.com/wd/hub"
  CapybaraHelpers.cloud_driver(app, caps, url)
end

# :selenium_grid driver

Capybara.register_driver :selenium_grid do |app|
  caps = if CapybaraHelpers.ie_browser?
           Selenium::WebDriver::Remote::Capabilities.internet_explorer
         elsif CapybaraHelpers.ff_browser?
           Selenium::WebDriver::Remote::Capabilities.firefox
         elsif CapybaraHelpers.chrome_browser?
           Selenium::WebDriver::Remote::Capabilities.chrome
         elsif CapybaraHelpers.safari_browser?
           Selenium::WebDriver::Remote::Capabilities.safari
         else
           raise Howitzer::UnknownBrowserError, "Unknown '#{Howitzer.selenium_browser}' selenium_browser." \
                     ' Check your settings, it should be one of' \
                     ' [:ie, :iexplore, :ff, :firefox, :chrome, safari]'
         end

  Capybara::Selenium::Driver.new(app, browser: :remote, url: Howitzer.selenium_hub_url, desired_capabilities: caps)
end

Capybara.save_path = Howitzer.log_dir
Capybara::Screenshot.register_driver(:phantomjs) do |driver, path|
  driver.browser.save_screenshot path
end
Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot path
end
Capybara::Screenshot.append_timestamp = false
Capybara::Screenshot.register_filename_prefix_formatter(:default) do
  "capybara-screenshot-#{Gen.serial}"
end
Capybara::Screenshot.prune_strategy = :keep_all
