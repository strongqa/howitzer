# The base model. Models allow to communicate with
# AUT (application under test) api endpoints. They are used by
# FactoryBot on create
#
# To implement a custom model, override the following methods:
# * {Base.find}
# * {Base.where}
# * {Base.save!}
#
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
