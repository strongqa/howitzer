require_relative '../base_generator'

module Howitzer
  # This class responsible for prerequisites files generation
  class PrerequisitesGenerator < BaseGenerator
    def manifest
      { files:
          [
            { source: 'factory_bot.rb', destination: 'prerequisites/factory_bot.rb' },
            { source: 'users.rb', destination: 'prerequisites/factories/users.rb' },
            { source: 'base.rb', destination: 'prerequisites/models/base.rb' },
            { source: 'user.rb', destination: 'prerequisites/models/user.rb' }
          ] }
    end

    protected

    def banner
      <<-MSG
  * Pre-requisites integration to the framework ...
      MSG
    end
  end
end
