# :headless_chrome driver

Capybara.register_driver :headless_chrome do |app|
  startup_flags = ['headless']
  startup_flags << 'start-fullscreen' if Howitzer.maximized_window
  startup_flags << "user-agent=#{Howitzer.user_agent}" if Howitzer.user_agent.present?
  startup_flags.concat(Howitzer.headless_chrome_flags.split(/\s*,\s*/)) if Howitzer.headless_chrome_flags
  options = Selenium::WebDriver::Chrome::Options.new(args: startup_flags)
  params = { browser: :chrome, options: options }
  Capybara::Selenium::Driver.new app, params
end

Capybara.save_path = Howitzer.log_dir
Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot path
end
