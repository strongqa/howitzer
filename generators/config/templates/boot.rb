require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

Dir[
  './emails/**/*.rb',
  './web/sections/**/*.rb',
  './web/pages/**/*.rb',
  './prerequisites/models/**/*.rb',
  './prerequisites/factory_girl.rb'
].each { |f| require f }

pid = Process.pid
Pry.hooks.add_hook(:after_session, 'shutdown_on_binding_exit') do
  Process.kill(2, pid)
end

String.send(:include, Howitzer::Utils::StringExtensions)
