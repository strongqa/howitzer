HOWITZER_KNOWN_DRIVERS = [
  :selenium,
  :selenium_grid,
  :webkit,
  :poltergeist,
  :phantomjs,
  :sauce,
  :testingbot,
  :browserstack
].freeze
unless HOWITZER_KNOWN_DRIVERS.include?(settings.driver.to_s.to_sym)
  log.error "Unknown '#{settings.driver}' driver. Check your settings, it should be one of #{HOWITZER_KNOWN_DRIVERS}"
end

Capybara.configure do |config|
  config.run_server = false
  config.app_host = ''
  config.asset_host = Howitzer::Helpers.app_base_url
  config.default_selector = :css
  config.default_max_wait_time = settings.timeout_small
  config.ignore_hidden_elements = true
  config.match = :one
  config.exact = true
  config.visible_text_only = true
  config.default_driver = settings.driver.to_s.to_sym
  config.javascript_driver = settings.driver.to_s.to_sym
end

# :selenium driver

Capybara.register_driver :selenium do |app|
  params = { browser: settings.sel_browser.to_s.to_sym }
  if Howitzer::Helpers.ff_browser?
    ff_profile = Selenium::WebDriver::Firefox::Profile.new.tap do |profile|
      profile['network.http.phishy-userpass-length'] = 255
      profile['browser.safebrowsing.malware.enabled'] = false
      profile['network.automatic-ntlm-auth.allow-non-fqdn'] = true
      profile['network.ntlm.send-lm-response'] = true
      profile['network.automatic-ntlm-auth.trusted-uris'] = settings.app_host
    end
    params[:profile] = ff_profile
  end
  Capybara::Selenium::Driver.new app, params
end

# :webkit driver

if settings.driver.to_s.to_sym == :webkit
  Howitzer::Helpers.load_driver_gem!(:webkit, 'capybara-webkit', 'capybara-webkit')
end

# :poltergeist driver

if settings.driver.to_s.to_sym == :poltergeist
  Howitzer::Helpers.load_driver_gem!(:poltergeist, 'capybara/poltergeist', 'poltergeist')

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      js_errors: !settings.pjs_ignore_js_errors,
      phantomjs_options: ["--ignore-ssl-errors=#{settings.pjs_ignore_ssl_errors ? 'yes' : 'no'}"]
    )
  end
end

# :phantomjs driver

Capybara.register_driver :phantomjs do |app|
  Capybara::Selenium::Driver.new(
    app, browser: :phantomjs,
         desired_capabilities: {
           javascript_enabled: !settings.pjs_ignore_js_errors
         },
         args: ["--ignore-ssl-errors=#{settings.pjs_ignore_ssl_errors ? 'yes' : 'no'}"]
  )
end

# :sauce driver

Capybara.register_driver :sauce do |app|
  caps_opts = {
    platform: settings.sl_platform,
    browser_name: settings.sl_browser_name,
    name: "#{Howitzer::Helpers.prefix_name} #{settings.sl_browser_name.upcase}",
    'max-duration' => settings.sl_max_duration,
    'idle-timeout' => settings.sl_idle_timeout,
    'selenium-version' => settings.sl_selenium_version,
    'record-screenshots' => settings.sl_record_screenshot,
    'video-upload-on-pass' => settings.sl_video_upload_on_pass
  }

  unless (settings.sl_browser_version.to_s || '').empty?
    caps_opts['version'] = settings.sl_browser_version.to_s
  end

  options = {
    url: settings.sl_url,
    desired_capabilities: ::Selenium::WebDriver::Remote::Capabilities.new(caps_opts),
    http_client: ::Selenium::WebDriver::Remote::Http::Default.new.tap { |c| c.timeout = settings.timeout_medium },
    browser: :remote
  }

  driver = Capybara::Selenium::Driver.new(app, options)
  driver.browser.file_detector = lambda do |args|
    str = args.first.to_s
    str if File.exist?(str)
  end
  driver
end

# :testingbot driver

if settings.driver.to_s.to_sym == :testingbot
  Howitzer::Helpers.load_driver_gem!(:testingbot, 'testingbot', 'testingbot')

  Capybara.register_driver :testingbot do |app|
    caps_opts = {
      platform: settings.tb_platform,
      browser_name: settings.tb_browser_name,
      name: "#{Howitzer::Helpers.prefix_name} #{settings.tb_browser_name.upcase}",
      maxduration: settings.tb_max_duration.to_i,
      idletimeout: settings.tb_idle_timeout.to_i,
      'selenium-version' => settings.tb_selenium_version,
      screenshot: settings.tb_record_screenshot,
      'avoid-proxy' => settings.tb_avoid_proxy
    }

    unless (settings.tb_browser_version.to_s || '').empty?
      caps_opts['version'] = settings.tb_browser_version.to_s
    end
    options = {
      url: settings.tb_url,
      desired_capabilities: ::Selenium::WebDriver::Remote::Capabilities.new(caps_opts),
      http_client: ::Selenium::WebDriver::Remote::Http::Default.new.tap { |c| c.timeout = settings.timeout_medium },
      browser: :remote
    }

    driver = Capybara::Selenium::Driver.new(app, options)
    driver.browser.file_detector = lambda do |args|
      str = args.first.to_s
      str if File.exist?(str)
    end
    driver
  end
end

# :browserstack driver

Capybara.register_driver :browserstack do |app|
  name = Howitzer::Helpers.prefix_name.to_s +
         (settings.bs_mobile ? settings.bs_m_browser : settings.bs_browser_name.upcase).to_s
  caps_opts = {
    name: name,
    maxduration: settings.bs_max_duration.to_i,
    idletimeout: settings.bs_idle_timeout.to_i,
    project: settings.bs_project,
    build: settings.bs_build,
    resolution: settings.bs_resolution
  }

  if settings.bs_local
    caps_opts['browserstack.local'] = settings.bs_local
    caps_opts['browserstack.localIdentifier'] = settings.bs_local_ID
  end

  if settings.bs_mobile
    caps_opts[:browserName] = settings.bs_m_browser
    caps_opts[:platform] = settings.bs_m_platform
    caps_opts[:device] = settings.bs_m_device
  else
    caps_opts[:os] = settings.bs_os_name
    caps_opts[:os_version] = settings.bs_os_version
    caps_opts[:browser] = settings.bs_browser_name
    caps_opts[:browser_version] = settings.bs_browser_version
  end

  options = {
    url: settings.bs_url,
    desired_capabilities: ::Selenium::WebDriver::Remote::Capabilities.new(caps_opts),
    browser: :remote
  }

  driver = Capybara::Selenium::Driver.new(app, options)
  driver.browser.file_detector = lambda do |args|
    str = args.first.to_s
    str if File.exist?(str)
  end

  driver
end

# :selenium_grid driver

Capybara.register_driver :selenium_grid do |app|
  caps = if Howitzer::Helpers.ie_browser?
           Selenium::WebDriver::Remote::Capabilities.internet_explorer
         elsif Howitzer::Helpers.ff_browser?
           Selenium::WebDriver::Remote::Capabilities.firefox
         elsif Howitzer::Helpers.chrome_browser?
           Selenium::WebDriver::Remote::Capabilities.chrome
         elsif Howitzer::Helpers.safari_browser?
           Selenium::WebDriver::Remote::Capabilities.safari
         else
           log.error "Unknown '#{settings.sel_browser}' sel_browser. Check your settings, it should be one of" \
                     ' [:ie, :iexplore, :ff, :firefox, :chrome, safari]'
         end

  Capybara::Selenium::Driver.new(app, browser: :remote, url: settings.sel_hub_url, desired_capabilities: caps)
end
