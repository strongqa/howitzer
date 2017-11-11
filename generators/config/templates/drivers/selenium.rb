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
      profile['general.useragent.override'] = Howitzer.user_agent if Howitzer.user_agent.present?
    end
    options = Selenium::WebDriver::Firefox::Options.new(profile: ff_profile)
    params[:options] = options
  end
  if CapybaraHelpers.chrome_browser?
    args = []
    args << 'start-fullscreen' if Howitzer.maximized_window
    args << "user-agent=#{Howitzer.user_agent}" if Howitzer.user_agent.present?
    params[:options] = Selenium::WebDriver::Chrome::Options.new(args: args)
  end
  Capybara::Selenium::Driver.new app, params
end
