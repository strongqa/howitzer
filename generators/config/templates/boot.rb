require 'rubygems'
require 'bundler/setup'
require 'howitzer/gmail_api/client'

Bundler.require(:default)

Dir[
  './emails/**/*.rb',
  './web/sections/**/*.rb',
  './web/pages/**/*.rb',
  './prerequisites/models/**/*.rb',
  './prerequisites/factory_girl.rb'
].each { |f| require f }

Howitzer::GmailApi::Client.new if Howitzer.mail_adapter == 'gmail'

String.send(:include, Howitzer::Utils::StringExtensions)
