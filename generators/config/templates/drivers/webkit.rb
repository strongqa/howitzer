# :webkit driver

CapybaraHelpers.load_driver_gem!(:webkit, 'capybara-webkit', 'capybara-webkit')
Capybara::Webkit.configure do |config|
  config.allow_url(Howitzer.app_host)
end

Capybara::Screenshot.register_driver(:webkit) do |driver, path|
  if driver.respond_to?(:save_screenshot)
    driver.save_screenshot(path)
  else
    driver.render(path)
  end
end
