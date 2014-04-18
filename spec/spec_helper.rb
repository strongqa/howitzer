require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'tmpdir'
require 'ffaker'
require 'capybara'
require 'json'
require 'capybara/dsl'
require 'active_support'
require 'active_support/core_ext'
require 'repeater'
require 'howitzer/exceptions'
require 'howitzer/utils/log'

SimpleCov.start do
  add_filter "/spec/"
  add_filter '/config/'
  add_filter do |source_file|
    source_file.lines.count < 5
  end
  add_group "generators", "/generators"
  add_group "lib", "/lib"
end

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each{ |f| require f }

RSpec.configure do |config|
  config.include GeneratorHelper
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.mock_with :rspec do |c|
    c.syntax = :expect
  end
  config.around(:each) do |ex|
    $stdout = StringIO.new
    $stderr = StringIO.new
    ex.run
    $stdout = STDOUT
    $stderr = STDERR
  end
end

def project_path
  File.expand_path(File.join(File.dirname(__FILE__), '..'))
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
