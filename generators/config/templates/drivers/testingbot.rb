# :testingbot driver

Capybara.register_driver :testingbot do |app|
  url = "https://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@hub.testingbot.com/wd/hub"
  if CapybaraHelpers.w3c_selenium?
    caps = CapybaraHelpers.required_w3c_cloud_caps
    caps[:platformName] = Howitzer.cloud_platform unless Howitzer.cloud_platform.casecmp?('any')
    tb_options = {
      name: "#{(Howitzer.current_rake_task || 'ALL').upcase} #{Howitzer.cloud_browser_name}",
      maxduration: Howitzer.cloud_max_duration,
      idletimeout: Howitzer.cloud_testingbot_idle_timeout,
      screenshot: Howitzer.cloud_testingbot_screenshots
    }
    caps['tb:options'] = tb_options
    if Howitzer.user_agent.present?
      if CapybaraHelpers.chrome_browser?
        caps['goog:chromeOptions'] = { 'args' => ["--user-agent=#{Howitzer.user_agent}"] }
      elsif CapybaraHelpers.ff_browser?
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile['general.useragent.override'] = Howitzer.user_agent
        caps['moz:firefoxOptions'] = { profile: profile.as_json['zip'] }
      end
    end
  else
    caps = CapybaraHelpers.required_cloud_caps.merge(
      maxduration: Howitzer.cloud_max_duration,
      idletimeout: Howitzer.cloud_testingbot_idle_timeout,
      screenshot: Howitzer.cloud_testingbot_screenshots
    )
    if Howitzer.user_agent.present?
      if CapybaraHelpers.chrome_browser?
        caps['chromeOptions'] = { 'args' => ["--user-agent=#{Howitzer.user_agent}"] }
      elsif CapybaraHelpers.ff_browser?
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile['general.useragent.override'] = Howitzer.user_agent
        caps[:firefox_profile] = profile
      end
    end
  end
  CapybaraHelpers.cloud_driver(app, caps, url)
end

Capybara::Screenshot.class_eval do
  register_driver :testingbot, &registered_drivers[:selenium]
end
