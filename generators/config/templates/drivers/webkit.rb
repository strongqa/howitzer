# :webkit driver

CapybaraHelpers.load_driver_gem!(:webkit, 'capybara-webkit', 'capybara-webkit')
Capybara::Webkit.configure do |config|
  config.allow_url(Howitzer.app_host)
end
