Dir.chdir(File.join(File.dirname(__FILE__), '.'))

def settings
  SexySettings::Base.instance
end

require 'howitzer'
require 'her'

Dir[File.join(File.dirname(__FILE__), "./emails/**/*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "./pages/**/*.rb")].each {|f| require f}

Dir[File.join(File.dirname(__FILE__), "./pre_requisites/models/**/*.rb")].each {|f| require f}
require File.join(File.dirname(__FILE__), "pre_requisites/factory_girl")