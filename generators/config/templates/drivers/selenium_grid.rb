# :selenium_grid driver

Capybara.register_driver :selenium_grid do |app|
  caps = if CapybaraHelpers.ie_browser?
           Selenium::WebDriver::Remote::Capabilities.internet_explorer
         elsif CapybaraHelpers.ff_browser?
           Selenium::WebDriver::Remote::Capabilities.firefox
         elsif CapybaraHelpers.chrome_browser?
           Selenium::WebDriver::Remote::Capabilities.chrome
         elsif CapybaraHelpers.safari_browser?
           Selenium::WebDriver::Remote::Capabilities.safari
         else
           raise Howitzer::UnknownBrowserError, "Unknown '#{Howitzer.selenium_browser}' selenium_browser." \
                     ' Check your settings, it should be one of' \
                     ' [:ie, :iexplore, :ff, :firefox, :chrome, :safari]'
         end
  if Howitzer.user_agent.present?
    if CapybaraHelpers.chrome_browser?
      caps['chromeOptions'] = { 'args' => ["--user-agent=#{Howitzer.user_agent}"] }
    elsif CapybaraHelpers.ff_browser?
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['general.useragent.override'] = Howitzer.user_agent
      caps[:firefox_profile] = profile
    end
  end
  Capybara::Selenium::Driver.new(app, browser: :remote, url: Howitzer.selenium_hub_url, desired_capabilities: caps)
end
