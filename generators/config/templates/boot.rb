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

String.send(:include, Howitzer::Utils::StringExtensions)
