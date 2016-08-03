require 'cucumber'
require 'capybara/cucumber'
require_relative '../../boot'
require_relative '../../config/capybara'

World(FactoryGirl::Syntax::Methods)
World(Howitzer::Helpers)

FileUtils.mkdir_p(Howitzer.settings.log_dir)

log.settings_as_formatted_text
Howitzer::Utils::DataStorage.store('sauce', :start_time, Time.now.utc)
Howitzer::Utils::DataStorage.store('sauce', :status, true)

if Howitzer::Helpers.sauce_driver?
  Capybara.drivers[:sauce][].options[:desired_capabilities][:name] = Howitzer::Helpers.suite_name
end

Before do |scenario|
  log.print_feature_name(scenario.feature.name)
  log.print_scenario_name(scenario.name)
  @session_start = duration(Time.now.utc - Howitzer::Utils::DataStorage.extract('sauce', :start_time))
end

After do |scenario|
  if sauce_driver?
    Howitzer::Utils::DataStorage.store('sauce', :status, false) if scenario.failed?
    session_end = duration(Time.now.utc - Howitzer::Utils::DataStorage.extract('sauce', :start_time))
    log.info "SAUCE VIDEO #{@session_start} - #{session_end} URL: #{sauce_resource_path('video.flv')}"
  elsif ie_browser?
    log.info 'IE reset session'
    page.execute_script("void(document.execCommand('ClearAuthenticationCache', false));")
  end
  Howitzer::Utils::DataStorage.clear_all_ns
end

at_exit do
  if Howitzer::Helpers.sauce_driver?
    log.info "SAUCE SERVER LOG URL: #{Howitzer::Helpers.sauce_resource_path('selenium-server.log')}"
    Howitzer::Helpers.update_sauce_job_status(passed: Howitzer::Utils::DataStorage.extract('sauce', :status))
  end
end

# TODO: try to remove extra namespaces like Howitzer::Utils::
