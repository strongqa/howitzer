# :webkit driver

CapybaraHelpers.load_driver_gem!(:webkit, 'capybara-webkit', 'capybara-webkit')
Capybara::Webkit.configure do |config|
  config.allow_url(Howitzer.app_host)
end
Capybara.current_session.driver.header('User-Agent', Howitzer.user_agent) if Howitzer.user_agent.present?
