# @see http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
require 'factory_girl'

FactoryGirl.definition_file_paths = [File.join(__dir__, 'factories')]
FactoryGirl.find_definitions

# This module holds custom FactoryGirl methods
module FactoryGirl
  # Fetches data from the cache, using factory name and number.
  # If there is data in the cache with the given name and number,
  # then that data is returned. Otherwise it stores firstly and then returns
  # @param factory [String] underscored factory name
  # @param num [Integer] a factory number
  # @return [Object] the factory
  def self.given_by_number(factory, num)
    data = Howitzer::Cache.extract(factory, num.to_i)
    return data if data.present?
    Howitzer::Cache.store(factory, num.to_i, build(factory))
  end
end

# This module holds data generators
module Gen
  # Generates unique string
  # @return [String]
  def self.serial
    a = [('a'..'z').to_a, (0..9).to_a].flatten.shuffle
    "#{Time.now.utc.strftime('%j%H%M%S')}#{a[0..4].join}"
  end
end
