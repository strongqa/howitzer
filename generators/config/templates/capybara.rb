HOWITZER_KNOWN_DRIVERS = %i[
  selenium
  selenium_grid
  webkit
  poltergeist
  phantomjs
  sauce
  testingbot
  browserstack
  crossbrowsertesting
  headless_chrome
].freeze

unless HOWITZER_KNOWN_DRIVERS.include?(Howitzer.driver.to_s.to_sym)
  raise Howitzer::UnknownDriverError, "Unknown '#{Howitzer.driver}' driver." \
                      " Check your settings, it should be one of #{HOWITZER_KNOWN_DRIVERS}"
end

Capybara.configure do |config|
  config.run_server = false
  config.app_host = nil
  config.asset_host = Howitzer.app_uri.origin
  config.default_selector = :css
  config.default_max_wait_time = Howitzer.capybara_wait_time
  config.ignore_hidden_elements = true
  config.match = :one
  config.exact = true
  config.visible_text_only = true
  config.default_driver = Howitzer.driver.to_s.to_sym
  config.javascript_driver = Howitzer.driver.to_s.to_sym
end

require 'howitzer/capybara_helpers'

# namespace for capybara helpers
module CapybaraHelpers
  extend Howitzer::CapybaraHelpers
end

require_relative "drivers/#{Howitzer.driver}"

Capybara.save_path = Howitzer.log_dir

Capybara::Screenshot.append_timestamp = false
Capybara::Screenshot.register_filename_prefix_formatter(:default) do
  "capybara-screenshot-#{Gen.serial}"
end
Capybara::Screenshot.prune_strategy = :keep_all
