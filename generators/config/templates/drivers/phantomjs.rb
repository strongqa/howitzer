# :phantomjs driver

Capybara.register_driver :phantomjs do |app|
  caps = {
    javascript_enabled: !Howitzer.phantom_ignore_js_errors
  }
  caps['phantomjs.page.settings.userAgent'] = "WebKit #{Howitzer.user_agent}" if Howitzer.user_agent.present?
  Capybara::Selenium::Driver.new(
    app, browser: :phantomjs,
         desired_capabilities: caps,
         driver_opts: {
           args: ["--ignore-ssl-errors=#{Howitzer.phantom_ignore_ssl_errors ? 'yes' : 'no'}"]
         }
  )
end

Capybara.save_path = Howitzer.log_dir
Capybara::Screenshot.register_driver(:phantomjs) do |driver, path|
  driver.browser.save_screenshot path
end
