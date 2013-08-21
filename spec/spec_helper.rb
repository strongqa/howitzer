require 'rubygems'
require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  add_group "bin", "bin"
  add_group "generators", "generators"
  add_group "lib", "lib"
end

RSpec.configure do |configuration|
  configuration.mock_with :rspec do |configuration|
    configuration.syntax = :expect
  end
end