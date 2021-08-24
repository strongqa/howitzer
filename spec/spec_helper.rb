require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'coveralls'
Coveralls.wear!
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
)

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter do |source_file|
    source_file.lines.count < 5
  end
  add_group 'generators', '/generators'
  add_group 'lib', '/lib'
end

require 'tmpdir'
require 'ffaker'
require 'capybara'
require 'json'
require 'capybara/dsl'
require 'active_support'
require 'active_support/deprecation'
require 'active_support/deprecation/method_wrappers'
require 'active_support/core_ext'
require 'repeater'
require 'sexy_settings'
require 'fake_web'

SexySettings.configure do |config|
  config.path_to_default_settings = File.expand_path(
    'default.yml',
    File.join(__dir__, '..', 'generators', 'config', 'templates')
  )
  config.path_to_custom_settings = File.expand_path(
    'custom.yml',
    File.join(__dir__, 'config')
  )
end

puts SexySettings::Base.instance.as_formatted_text

require 'howitzer'
require 'howitzer/exceptions'

def project_path
  File.expand_path(File.join(__dir__, '..'))
end

def lib_path
  File.join(project_path, 'lib')
end

def generators_path
  File.join(project_path, 'generators')
end

def log_path
  File.join(project_path, 'spec/log')
end

Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.include Howitzer::GeneratorHelper
  config.disable_monkey_patching!
end
