require_relative 'base'
# Example Model class
class User < Base
  def self.default
    where(email: Howitzer.app_test_user).first
  end
end
