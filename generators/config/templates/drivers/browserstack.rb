def w3c_selenium_browserstack_caps # rubocop:disable Metrics/AbcSize
  caps = CapybaraHelpers.required_w3c_cloud_caps
  bstack_options = {
    sessionName: "#{(Howitzer.current_rake_task || 'ALL').upcase} #{Howitzer.cloud_browser_name}",
    projectName: Howitzer.cloud_bstack_project,
    buildName: Howitzer.cloud_bstack_build
  }
  bstack_options['resolution'] = Howitzer.cloud_bstack_resolution if Howitzer.cloud_bstack_resolution.present?
  bstack_options['os'] = Howitzer.cloud_bstack_os if Howitzer.cloud_bstack_os.present?
  caps['bstack:options'] = bstack_options
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
    project: Howitzer.cloud_bstack_project,
    build: Howitzer.cloud_bstack_build
  )
  caps['resolution'] = Howitzer.cloud_bstack_resolution if Howitzer.cloud_bstack_resolution.present?
  caps['os'] = Howitzer.cloud_bstack_os if Howitzer.cloud_bstack_os.present?
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

Capybara.register_driver :browserstack do |app|
  url = "https://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@hub.browserstack.com/wd/hub"
  caps = CapybaraHelpers.w3c_selenium? ? w3c_selenium_browserstack_caps : classic_selenium_browserstack_caps
  CapybaraHelpers.cloud_driver(app, caps, url)
end

Capybara::Screenshot.class_eval do
  register_driver :browserstack, &registered_drivers[:selenium]
end
