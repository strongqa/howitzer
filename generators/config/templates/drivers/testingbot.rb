# :testingbot driver

Capybara.register_driver :testingbot do |app|
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
  url = "http://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@hub.testingbot.com/wd/hub"
  CapybaraHelpers.cloud_driver(app, caps, url)
end
