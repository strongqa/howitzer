require 'factory_girl'

FactoryGirl.define do
  sequence :serial do
    a = [('a'..'z').to_a, (0..9).to_a].flatten.shuffle
    "#{Time.now.utc.strftime("%j%H%M%S")}#{a[0..4].join}"
  end
end

FactoryGirl.definition_file_paths = [File.join(File.dirname(__FILE__), "pre_requisites/factories")]
FactoryGirl.find_definitions

class FactoryGirl
  def self.given_factory_by_number(factory, num)
    data = DataStorage.extract(factory, num.to_i)
    unless data
      data = FactoryGirl.build(factory)
      DataStorage.store(factory, num.to_i, data)
    end
    data
  end
end

