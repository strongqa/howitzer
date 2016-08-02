Dir.chdir(File.join(File.dirname(__FILE__), '.'))

def settings
  SexySettings::Base.instance
end

def log
  Howitzer::Utils::Log.instance
end

require 'howitzer'

Dir[File.join(File.dirname(__FILE__), './emails/**/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), './web/sections/**/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), './web/pages/**/*.rb')].each { |f| require f }

require File.join(File.dirname(__FILE__), 'prerequisites/her')
Dir[File.join(File.dirname(__FILE__), './prerequisites/models/**/*.rb')].each { |f| require f }
require File.join(File.dirname(__FILE__), 'prerequisites/factory_girl')

String.send(:include, Howitzer::Utils::StringExtensions)
