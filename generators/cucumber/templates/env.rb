require 'cucumber'
require 'capybara/cucumber'
require_relative '../../boot'

World(Capybara::Settings)
World(DataGenerator)

log.settings_as_formatted_text
DataStorage.store('sauce', :start_time, Time.now.utc)
DataStorage.store('sauce', :status, true)

if sauce_driver?
  Capybara.drivers[:sauce][].options[:desired_capabilities][:name] = Capybara::Settings.suite_name
end

Before do |scenario|
  log.print_feature_name(scenario.feature.title)
  log.print_scenario_name(scenario.name)
  @session_start = duration(Time.now.utc - DataStorage.extract('sauce', :start_time))
end

After do |scenario|
  if sauce_driver?
    DataStorage.store('sauce', :status, false) if scenario.failed?
    session_end = duration(Time.now.utc - DataStorage.extract('sauce', :start_time))
    log.info "SAUCE VIDEO #@session_start - #{session_end} URL: #{sauce_resource_path('video.flv')}"
  elsif ie_browser?
    log.info 'IE reset session'
    page.execute_script("void(document.execCommand('ClearAuthenticationCache', false));")
  end
  DataStorage.clear_all_ns
end

at_exit do
  if sauce_driver?
    log.info "SAUCE SERVER LOG URL: #{Capybara::Settings.sauce_resource_path('selenium-server.log')}"
    Capybara::Settings.update_sauce_job_status(passed: DataStorage.extract('sauce', :status))
  end
end