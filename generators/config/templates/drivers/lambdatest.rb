Capybara.register_driver :lambdatest do |app|
  url = "https://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@hub.lambdatest.com/wd/hub"
  if CapybaraHelpers.w3c_selenium?
    caps = CapybaraHelpers.required_w3c_cloud_caps
    lt_options = {
      name: "#{(Howitzer.current_rake_task || 'ALL').upcase} #{Howitzer.cloud_browser_name}",
      build: Howitzer.cloud_lambdatest_build
    }
    lt_options[:platformName] = Howitzer.cloud_platform unless Howitzer.cloud_platform.casecmp?('any')
    lt_options[:resolution] = Howitzer.cloud_lambdatest_resolution if Howitzer.cloud_lambdatest_resolution.present?
    caps['LT:Options'] = lt_options
  else
    caps = CapybaraHelpers.required_cloud_caps.merge(
      build: Howitzer.cloud_lambdatest_build,
      acceptSslCerts: true
    )
    caps[:resolution] = Howitzer.cloud_lambdatest_resolution if Howitzer.cloud_lambdatest_resolution.present?
  end
  CapybaraHelpers.cloud_driver(app, caps, url)
end

Capybara::Screenshot.class_eval do
  register_driver :lambdatest, &registered_drivers[:selenium]
end
