Capybara.register_driver :lambdatest do |app|
  caps = CapybaraHelpers.required_cloud_caps.merge(
    project: Howitzer.cloud_lambdatest_project,
    build: Howitzer.cloud_lambdatest_build,
    nativeEvents: true,
    'ie.ensureCleanSession': 'true',
    acceptSslCerts: true
  )
  caps[:resolution] = Howitzer.cloud_lambdatest_resolution if Howitzer.cloud_lambdatest_resolution.present?
  caps[:device] = Howitzer.cloud_lambdatest_mobile_device if Howitzer.cloud_lambdatest_mobile_device.present?
  url = "https://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@hub.lambdatest.com/wd/hub"
  CapybaraHelpers.cloud_driver(app, caps, url)
end

Capybara::Screenshot.class_eval do
  register_driver :lambdatest, &registered_drivers[:selenium]
end
