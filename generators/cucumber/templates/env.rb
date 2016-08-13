require 'cucumber'
require 'capybara/cucumber'
require_relative '../../boot'
require_relative '../../config/capybara'

World(FactoryGirl::Syntax::Methods)

FileUtils.mkdir_p(Howitzer.log_dir)

log.settings_as_formatted_text
cache.store(:cloud, :start_time, Time.now.utc)
cache.store(:cloud, :status, true)

if cloud_driver?
  Capybara.drivers[Howitzer.driver.to_sym][].options[:desired_capabilities][:name] = suite_name
  Capybara.current_session # we force new session creating to register at_exit callback on browser method
end

Before do |scenario|
  log.print_feature_name(scenario.feature.name)
  log.print_scenario_name(scenario.name)
  @session_start = duration(Time.now.utc - cache.extract(:cloud, :start_time))
end

After do |scenario|
  if cloud_driver?
    cache.store(:cloud, :status, false) if scenario.failed?
    session_end = duration(Time.now.utc - cache.extract(:cloud, :start_time))
    log.info "CLOUD VIDEO #{@session_start} - #{session_end}" \
             " URL: #{cloud_resource_path(:video)}"
  elsif ie_browser?
    log.info 'IE reset session'
    page.execute_script("void(document.execCommand('ClearAuthenticationCache', false));")
  end
  cache.clear_all_ns
end

at_exit do
  if cloud_driver?
    log.info "CLOUD SERVER LOG URL: #{cloud_resource_path(:server_log)}"
    update_cloud_job_status(passed: cache.extract(:cloud, :status))
  end
end
