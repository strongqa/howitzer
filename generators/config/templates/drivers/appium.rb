CapybaraHelpers.load_driver_gem!(:appium, 'appium_capybara', 'appium_capybara')

Capybara.register_driver(:appium) do |app|
  caps = {}
  caps['deviceName'] = Howitzer.appium_device_name
  caps['deviceOrientation'] = Howitzer.appium_device_orientation
  caps['platformVersion'] = Howitzer.appium_platform_version
  caps['platformName'] = Howitzer.appium_platform_name
  caps['browserName'] = Howitzer.appium_browser_name

  url = Howitzer.appium_url

  appium_lib_options = {
    server_url: url
  }
  all_options = {
    appium_lib: appium_lib_options,
    caps: caps
  }
  Appium::Capybara::Driver.new app, all_options
end

Capybara::Screenshot.class_eval do
  register_driver :appium, &registered_drivers[:selenium]
end
