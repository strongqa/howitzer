Capybara.register_driver :browserstack do |app|
  caps = CapybaraHelpers.required_cloud_caps.merge(
    project: Howitzer.cloud_bstack_project,
    build: Howitzer.cloud_bstack_build
  )
  caps[:resolution] = Howitzer.cloud_bstack_resolution if Howitzer.cloud_bstack_resolution.present?
  caps[:device] = Howitzer.cloud_bstack_mobile_device if Howitzer.cloud_bstack_mobile_device.present?
  if Howitzer.user_agent.present?
    if CapybaraHelpers.chrome_browser?
      caps['chromeOptions'] = { 'args' => ["--user-agent=#{Howitzer.user_agent}"] }
    elsif CapybaraHelpers.ff_browser?
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['general.useragent.override'] = Howitzer.user_agent
      caps[:firefox_profile] = profile
    end
  end
  url = "http://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@hub.browserstack.com/wd/hub"
  CapybaraHelpers.cloud_driver(app, caps, url)
end
