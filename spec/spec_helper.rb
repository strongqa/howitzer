require 'rubygems'
require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  add_group "bin", "bin"
  add_group "generators", "generators"
  add_group "lib", "lib"
end

RSpec.configure do |config|
end