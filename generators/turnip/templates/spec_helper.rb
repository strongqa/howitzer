require 'rspec'
require 'capybara/rspec'
require_relative '../boot'
require_relative '../config/capybara'

Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  Howitzer::Log.settings_as_formatted_text

  Howitzer::Cache.store(:cloud, :start_time, Time.now.utc)
  Howitzer::Cache.store(:cloud, :status, true)

  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::RSpecMatchers

  config.disable_monkey_patching = true
  config.color = true

  config.before(type: :feature) do
    Howitzer::Log.print_scenario_name(
      self.class.description.empty? ? self.class.metadata[:description] : self.class.description
    )
    @session_start = CapybaraHelpers.duration(Time.now.utc - Howitzer::Cache.extract(:cloud, :start_time))
  end

  config.after(:each) do
    Howitzer::Cache.clear_all_ns
    if CapybaraHelpers.cloud_driver?
      session_end = CapybaraHelpers.duration(Time.now.utc - Howitzer::Cache.extract(:cloud, :start_time))
      Howitzer::Log.info "CLOUD VIDEO #{@session_start} - #{session_end}" \
               " URL: #{CapybaraHelpers.cloud_resource_path(:video)}"

    elsif CapybaraHelpers.ie_browser?
      Howitzer::Log.info 'IE reset session'
      page.execute_script("void(document.execCommand('ClearAuthenticationCache', false));")
    end
  end

  config.after(:suite) do
    if CapybaraHelpers.cloud_driver?
      report_failures_count = config.reporter.failed_examples.count
      Howitzer::Cache.store(:cloud, :status, report_failures_count.zero?)
    end
  end

  at_exit do
    if CapybaraHelpers.cloud_driver?
      Howitzer::Log.info "CLOUD SERVER LOG URL: #{CapybaraHelpers.cloud_resource_path(:server_log)}"
      CapybaraHelpers.update_cloud_job_status(passed: Howitzer::Cache.extract(:cloud, :status))
    end
  end
end
