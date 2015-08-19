require 'her'
require 'factory_girl'

module PreRequisites
  def given_factory_by_number(factory, num)
    data = DataStorage.extract(factory, num.to_i)
    unless data
      data = FactoryGirl.build(factory)
      DataStorage.store(factory, num.to_i, data)
    end
    data
  end
end