require_relative 'base'
# Example User Model
class User < Base
  attr_accessor :email, :name, :password, :password_confirmation

  def self.default
    where(email: Howitzer.app_test_user).first
  end
end
