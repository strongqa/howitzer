require 'rspec'
require 'capybara/rspec'
require_relative '../boot'

RSpec.configure do |config|
  log.settings_as_formatted_text

  DataStorage.store('sauce', :start_time, Time.now.utc)
  DataStorage.store('sauce', :status, true)

  config.include Capybara::Settings
  config.include Capybara::RSpecMatchers
  config.include DataGenerator

  config.disable_monkey_patching = true
  config.color = true

  config.before(:all) do
    if sauce_driver?
      suite_name = "#{(ENV['RAKE_TASK'] || 'CUSTOM').sub('rspec:', '').upcase} #{settings.sl_browser_name.upcase}"
      Capybara.drivers[:sauce][].options[:desired_capabilities][:name] = suite_name
    end
  end

  config.before(:each) do
    log.print_scenario_name(RSpec.current_example.description.empty? ? RSpec.current_example.metadata[:full_description] : RSpec.current_example.description)
    @session_start = duration(Time.now.utc - DataStorage.extract('sauce', :start_time))
  end

  config.after(:each) do
    DataStorage.clear_all_ns
    if sauce_driver?
      session_end = duration(Time.now.utc - DataStorage.extract('sauce', :start_time))
      log.info "SAUCE VIDEO #@session_start - #{session_end} URL: #{sauce_resource_path('video.flv')}"
    elsif ie_browser?
      log.info 'IE reset session'
      page.execute_script("void(document.execCommand('ClearAuthenticationCache', false));")
    end  
  end

  config.after(:suite) do
    if sauce_driver?
      report_failures_count = config.reporter.instance_variable_get(:@failure_count)
      DataStorage.store('sauce', :status, report_failures_count.zero?)
    end
  end

  at_exit do
    if sauce_driver?
      log.info "SAUCE SERVER LOG URL: #{CapybaraSettings.sauce_resource_path('selenium-server.log')}"
      CapybaraSettings.update_sauce_job_status(passed: DataStorage.extract('sauce', :status))
    end
  end
end