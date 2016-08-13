Dir.chdir(File.join(__dir__, '.'))

def log
  Howitzer::Utils::Log.instance
end

def cache
  Howitzer.cache
end

require 'howitzer'
require 'pry'
require 'pry-byebug'

Dir[File.join(__dir__, 'emails/**/*.rb')].each { |f| require f }
Dir[File.join(__dir__, 'web/sections/**/*.rb')].each { |f| require f }
Dir[File.join(__dir__, 'web/pages/**/*.rb')].each { |f| require f }

require File.join(__dir__, 'prerequisites/her')
Dir[File.join(__dir__, 'prerequisites/models/**/*.rb')].each { |f| require f }
require File.join(__dir__, 'prerequisites/factory_girl')

String.send(:include, Howitzer::Utils::StringExtensions)
