require 'cucumber'
require_relative '../../config/boot'
require_relative '../../config/capybara'

World(FactoryBot::Syntax::Methods)
World(RSpec::Wait)

RSpec.configure do |config|
  config.wait_timeout = Howitzer.rspec_wait_timeout
  config.disable_monkey_patching!
end

AfterConfiguration do |config|
  if Howitzer.test_order.present?
    order, seed = Howitzer.test_order.split(':')
    config.instance_variable_get(:@options)[:order] = order
    config.instance_variable_get(:@options)[:seed] ||= seed
  end
end

FileUtils.mkdir_p(Howitzer.log_dir)

Howitzer::Log.settings_as_formatted_text
Howitzer::Cache.store(:cloud, :start_time, Time.now.utc)
Howitzer::Cache.store(:cloud, :status, true)
