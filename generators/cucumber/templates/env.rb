require 'cucumber'
require 'capybara/cucumber'
require_relative '../../boot'
require_relative '../../config/capybara'

World(FactoryGirl::Syntax::Methods)

FileUtils.mkdir_p(Howitzer.log_dir)

Howitzer::Log.settings_as_formatted_text
Howitzer::Cache.store(:cloud, :start_time, Time.now.utc)
Howitzer::Cache.store(:cloud, :status, true)

if cloud_driver?
  Capybara.drivers[Howitzer.driver.to_sym][].options[:desired_capabilities][:name] = suite_name
  Capybara.current_session # we force new session creating to register at_exit callback on browser method
end

Before do |scenario|
  Howitzer::Log.print_feature_name(scenario.feature.name)
  Howitzer::Log.print_scenario_name(scenario.name)
  @session_start = duration(Time.now.utc - Howitzer::Cache.extract(:cloud, :start_time))
end

After do |scenario|
  if cloud_driver?
    Howitzer::Cache.store(:cloud, :status, false) if scenario.failed?
    session_end = duration(Time.now.utc - Howitzer::Cache.extract(:cloud, :start_time))
    Howitzer::Log.info "CLOUD VIDEO #{@session_start} - #{session_end}" \
             " URL: #{cloud_resource_path(:video)}"
  elsif ie_browser?
    Howitzer::Log.info 'IE reset session'
    page.execute_script("void(document.execCommand('ClearAuthenticationCache', false));")
  end
  Howitzer::Cache.clear_all_ns
end

at_exit do
  if cloud_driver?
    Howitzer::Log.info "CLOUD SERVER LOG URL: #{cloud_resource_path(:server_log)}"
    update_cloud_job_status(passed: Howitzer::Cache.extract(:cloud, :status))
  end
end
