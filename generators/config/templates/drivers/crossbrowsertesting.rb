# :crossbrowsertesting driver

Capybara.register_driver :crossbrowsertesting do |app|
  url = "https://#{CGI.escape(Howitzer.cloud_auth_login)}:#{Howitzer.cloud_auth_pass}" \
        '@hub.crossbrowsertesting.com/wd/hub'
  caps = CapybaraHelpers.required_cloud_caps.merge(
    build: Howitzer.cloud_cbt_build,
    screenResolution: Howitzer.cloud_cbt_screen_resolution,
    record_video: Howitzer.cloud_cbt_record_video,
    record_network: Howitzer.cloud_cbt_record_network,
    max_duration: Howitzer.cloud_max_duration
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
  CapybaraHelpers.cloud_driver(app, caps, url)
end

Capybara::Screenshot.class_eval do
  register_driver :crossbrowsertesting, &registered_drivers[:selenium]
end
