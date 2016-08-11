require 'rspec'
require 'capybara/rspec'
require_relative '../boot'
require_relative '../config/capybara'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  log.settings_as_formatted_text

  cache.store(:cloud, :start_time, Time.now.utc)
  cache.store(:cloud, :status, true)

  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::RSpecMatchers

  config.disable_monkey_patching = true
  config.color = true

  config.before(:each) do
    scenario_name =
      if RSpec.current_example.description.empty?
        RSpec.current_example.metadata[:full_description]
      else
        RSpec.current_example.description
      end
    log.print_scenario_name(scenario_name)
    @session_start = duration(Time.now.utc - cache.extract(:cloud, :start_time))
  end

  config.after(:each) do
    Howitzer::Utils::DataStorage.clear_all_ns
    if cloud_driver?
      session_end = duration(Time.now.utc - cache.extract(:cloud, :start_time))
      log.info "CLOUD VIDEO #{@session_start} - #{session_end}" \
               " URL: #{cloud_resource_path(:video)}"
    elsif ie_browser?
      log.info 'IE reset session'
      page.execute_script("void(document.execCommand('ClearAuthenticationCache', false));")
    end
  end

  config.after(:suite) do
    if cloud_driver?
      report_failures_count = config.reporter.failed_examples.count
      cache.store(:cloud, :status, report_failures_count.zero?)
    end
  end

  at_exit do
    if cloud_driver?
      log.info "CLOUD SERVER LOG URL: #{cloud_resource_path(:server_log)}"
      update_cloud_job_status(passed: cache.extract(:cloud, :status))
    end
  end
end
