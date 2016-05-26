require_relative '../base_generator'

module Howitzer
  # This class responsible for prerequisites files generation
  class PrerequisitesGenerator < BaseGenerator
    def manifest
      { files:
            [
              { source: 'factory_girl.rb', destination: 'prerequisites/factory_girl.rb' },
              { source: 'her.rb', destination: 'prerequisites/her.rb' },
              { source: 'users.rb', destination: 'prerequisites/factories/users.rb' },
              { source: 'user.rb', destination: 'prerequisites/models/user.rb' }
            ] }
    end

    protected

    def banner
      <<-EOS
  * Pre-requisites integration to the framework ...
      EOS
    end
  end
end
