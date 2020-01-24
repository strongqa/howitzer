require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

Dir[ # rubocop:disable Lint/NonDeterministicRequireOrder
  './emails/**/*.rb',
  './web/sections/**/*.rb',
  './web/pages/**/*.rb',
  './prerequisites/models/**/*.rb',
  './prerequisites/factory_bot.rb'
].sort.each { |f| require f }

String.include Howitzer::Utils::StringExtensions
