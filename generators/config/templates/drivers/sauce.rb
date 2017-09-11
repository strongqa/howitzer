# :sauce driver

Capybara.register_driver :sauce do |app|
  caps = CapybaraHelpers.required_cloud_caps.merge(
    maxDuration: Howitzer.cloud_max_duration,
    idleTimeout: Howitzer.cloud_sauce_idle_timeout,
    recordScreenshots: Howitzer.cloud_sauce_record_screenshots,
    videoUploadOnPass: Howitzer.cloud_sauce_video_upload_on_pass
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
  url = "http://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@ondemand.saucelabs.com:80/wd/hub"
  CapybaraHelpers.cloud_driver(app, caps, url)
end
