# For more information about configuration please refer to
# http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
require 'factory_girl'

FactoryGirl.definition_file_paths = [File.join(File.dirname(__FILE__), 'factories')]
FactoryGirl.find_definitions

# This module holds custom FactoryGirl methods
module FactoryGirl
  def self.given_factory_by_number(factory, num)
    data = DataStorage.extract(factory, num.to_i)
    unless data
      data = build(factory)
      DataStorage.store(factory, num.to_i, data)
    end
    data
  end
end
