# :poltergeist driver

CapybaraHelpers.load_driver_gem!(:poltergeist, 'capybara/poltergeist', 'poltergeist')

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    js_errors: !Howitzer.phantom_ignore_js_errors,
    phantomjs_options: ["--ignore-ssl-errors=#{Howitzer.phantom_ignore_ssl_errors ? 'yes' : 'no'}"]
  )
end
