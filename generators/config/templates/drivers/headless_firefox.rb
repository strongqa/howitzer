# :headless_firefox driver

Capybara.register_driver :headless_firefox do |app|
  startup_flags = ['--headless']
  startup_flags.concat(Howitzer.headless_firefox_flags.split(/\s*,\s*/)) if Howitzer.headless_firefox_flags
  ff_profile = Selenium::WebDriver::Firefox::Profile.new.tap do |profile|
    profile['network.http.phishy-userpass-length'] = 255
    profile['browser.safebrowsing.malware.enabled'] = false
    profile['network.automatic-ntlm-auth.allow-non-fqdn'] = true
    profile['network.ntlm.send-lm-response'] = true
    profile['network.automatic-ntlm-auth.trusted-uris'] = Howitzer.app_host
    profile['general.useragent.override'] = Howitzer.user_agent if Howitzer.user_agent.present?
  end
  options = Selenium::WebDriver::Firefox::Options.new(args: startup_flags, profile: ff_profile)
  params = { browser: :firefox, options: options }
  Capybara::Selenium::Driver.new app, params
end

Capybara.javascript_driver = :headless_firefox

Capybara::Screenshot.class_eval do
  register_driver :headless_firefox, &registered_drivers[:selenium]
end
