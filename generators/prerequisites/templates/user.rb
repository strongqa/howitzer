require_relative 'base'
# Example User Model
class User < Base
  def self.default
    where(email: Howitzer.app_test_user).first
  end
end
