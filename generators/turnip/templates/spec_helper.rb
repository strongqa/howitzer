require 'rspec'
require 'capybara/rspec'
require_relative '../boot'
require_relative '../config/capybara'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  log.settings_as_formatted_text

  Howitzer::Utils::DataStorage.store('sauce', :start_time, Time.now.utc)
  Howitzer::Utils::DataStorage.store('sauce', :status, true)

  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::RSpecMatchers
  config.include Howitzer::Helpers

  config.disable_monkey_patching = true
  config.color = true

  config.before(:all) do
    log.print_feature_name(self.class.description.empty? ? self.class.metadata[:description] : self.class.description)
    if Howitzer::Helpers.sauce_driver?
      suite_name = "#{(ENV['RAKE_TASK'] || 'CUSTOM').sub('rspec:', '').upcase} #{settings.sl_browser_name.upcase}"
      Capybara.drivers[:sauce][].options[:desired_capabilities][:name] = suite_name
    end
  end

  config.before(type: :feature) do
    log.print_scenario_name(self.class.description.empty? ? self.class.metadata[:description] : self.class.description)
    @session_start = duration(Time.now.utc - Howitzer::Utils::DataStorage.extract('sauce', :start_time))
  end

  config.after(:each) do
    Howitzer::Utils::DataStorage.clear_all_ns
    if Howitzer::Helpers.sauce_driver?
      session_end = duration(Time.now.utc - Howitzer::Utils::DataStorage.extract('sauce', :start_time))
      log.info "SAUCE VIDEO #{@session_start} - #{session_end} URL: #{sauce_resource_path('video.flv')}"
    elsif Howitzer::Helpers.ie_browser?
      log.info 'IE reset session'
      page.execute_script("void(document.execCommand('ClearAuthenticationCache', false));")
    end
  end

  config.after(:suite) do
    if Howitzer::Helpers.sauce_driver?
      report_failures_count = config.reporter.instance_variable_get(:@failure_count)
      Howitzer::Utils::DataStorage.store('sauce', :status, report_failures_count.zero?)
    end
  end

  at_exit do
    if Howitzer::Helpers.sauce_driver?
      log.info "SAUCE SERVER LOG URL: #{Howitzer::Helpers.sauce_resource_path('selenium-server.log')}"
      Howitzer::Helpers.update_sauce_job_status(passed: Howitzer::Utils::DataStorage.extract('sauce', :status))
    end
  end
end
