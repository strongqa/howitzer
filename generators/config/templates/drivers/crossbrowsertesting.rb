# :crossbrowsertesting driver

Capybara.register_driver :crossbrowsertesting do |app|
  caps = {}
  caps['name'] = Howitzer.cloud_cbt_name
  caps['build'] = Howitzer.cloud_cbt_build
  caps['browser_api_name'] = Howitzer.cloud_browser_name + Howitzer.cloud_browser_version.to_s
  caps['os_api_name'] = Howitzer.cloud_cbt_os_api_name
  caps['screen_resolution'] = Howitzer.cloud_cbt_screen_resolution
  caps['record_video'] = Howitzer.cloud_cbt_record_video
  caps['record_network'] = Howitzer.cloud_cbt_record_network
  caps['max_duration'] = Howitzer.cloud_max_duration
  if Howitzer.user_agent.present?
    if CapybaraHelpers.chrome_browser?
      caps['chromeOptions'] = { 'args' => ["--user-agent=#{Howitzer.user_agent}"] }
    elsif CapybaraHelpers.ff_browser?
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['general.useragent.override'] = Howitzer.user_agent
      caps[:firefox_profile] = profile
    end
  end
  url = "http://#{CGI.escape(Howitzer.cloud_auth_login)}:#{Howitzer.cloud_auth_pass}"\
        '@hub.crossbrowsertesting.com/wd/hub'
  CapybaraHelpers.cloud_driver(app, caps, url)
end
