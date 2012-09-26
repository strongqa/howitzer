require_relative 'boot'

require 'selenium-webdriver'
require 'rspec'

Dir[File.join(File.dirname(__FILE__), "../emails/*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "./lib/**/*.rb")].each {|f| require f}

include DataGenerator

include Capybara::DSL #TODO should be included to webpage instead of global content
require File.expand_path('helpers.rb', File.dirname(__FILE__))
require File.expand_path('web_page.rb', File.join(File.dirname(__FILE__)))

# Configure mail client
Mailgun::init(settings.mailgun_api_key)