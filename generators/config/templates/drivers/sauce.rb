# :sauce driver

def w3c_selenium_browserstack_caps # rubocop:disable Metrics/AbcSize
  caps = CapybaraHelpers.required_w3c_cloud_caps
  caps['platform'] = Howitzer.cloud_platform unless Howitzer.cloud_platform.casecmp?('any')
  sauce_options = {
    name: "#{(Howitzer.current_rake_task || 'ALL').upcase} #{Howitzer.cloud_browser_name}",
    maxDuration: Howitzer.cloud_max_duration,
    idleTimeout: Howitzer.cloud_sauce_idle_timeout,
    recordScreenshots: Howitzer.cloud_sauce_record_screenshots,
    videoUploadOnPass: Howitzer.cloud_sauce_video_upload_on_pass
  }
  caps['sauce:options'] = sauce_options
  if Howitzer.user_agent.present?
    if CapybaraHelpers.chrome_browser?
      caps['goog:chromeOptions'] = { 'args' => ["--user-agent=#{Howitzer.user_agent}"] }
    elsif CapybaraHelpers.ff_browser?
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['general.useragent.override'] = Howitzer.user_agent
      caps['moz:firefoxOptions'] = { profile: profile.as_json['zip'] }
    end
  end
  caps
end

def classic_selenium_browserstack_caps # rubocop:disable Metrics/AbcSize
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
  caps
end

Capybara.register_driver :sauce do |app|
  url = "https://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@ondemand.saucelabs.com/wd/hub"
  caps = CapybaraHelpers.w3c_selenium? ? w3c_selenium_browserstack_caps : classic_selenium_browserstack_caps
  CapybaraHelpers.cloud_driver(app, caps, url)
end

Capybara::Screenshot.class_eval do
  register_driver :sauce, &registered_drivers[:selenium]
end
