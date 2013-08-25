require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'tmpdir'

SimpleCov.start do
  add_group "bin", "bin"
  add_group "generators", "generators"
  add_group "lib", "lib"
end

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each{ |f| require f }

RSpec.configure do |config|
  config.include GeneratorHelper
  config.mock_with :rspec do |configuration|
    configuration.syntax = :expect
  end
end