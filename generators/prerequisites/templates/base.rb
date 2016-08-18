# Implement here methods via client API required for FactoryGirl gem
class Base
  def self.find(_id)
    raise NotImplementedError
  end

  def self.where(_params)
    raise NotImplementedError
  end

  def save!
    raise NotImplementedError
  end
end
