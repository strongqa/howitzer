# :headless_firefox driver

Capybara.register_driver :headless_firefox do |app|
  startup_flags = ['--headless']
  startup_flags.concat(Howitzer.headless_firefox_flags.split(/\s*,\s*/)) if Howitzer.headless_firefox_flags
  options = Selenium::WebDriver::Firefox::Options.new(args: startup_flags)
  params = { browser: :firefox, options: options }
  Capybara::Selenium::Driver.new app, params
end

Capybara.javascript_driver = :headless_firefox

Capybara::Screenshot.class_eval do
  register_driver :headless_firefox, &registered_drivers[:selenium]
end
