Dir.chdir(File.join(File.dirname(__FILE__), '.'))

def settings
  SexySettings::Base.instance
end

require 'howitzer'

Dir[File.join(File.dirname(__FILE__), "./emails/**/*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "./pages/**/*.rb")].each {|f| require f}

require File.join(File.dirname(__FILE__), "prerequisites/her")
Dir[File.join(File.dirname(__FILE__), "./prerequisites/models/**/*.rb")].each {|f| require f}
require File.join(File.dirname(__FILE__), "prerequisites/factory_girl")