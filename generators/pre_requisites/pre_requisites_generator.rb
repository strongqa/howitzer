require_relative '../base_generator'

module Howitzer
  class PreRequisitesGenerator < BaseGenerator
    def manifest
      { files:
            [
                { source: 'factory_girl.rb', destination: 'pre_requisites/factory_girl.rb'},
                { source: 'her.rb', destination: 'pre_requisites/her.rb'},
                { source: 'users.rb', destination: 'pre_requisites/factories/users.rb'},
                { source: 'user.rb', destination: 'pre_requisites/models/user.rb'},
            ]
      }
    end

    protected
    def banner
      <<-EOS
  * Pre-requisites integration to the framework ...
      EOS
    end

  end
end