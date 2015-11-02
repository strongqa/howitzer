require_relative '../base_generator'
module Howitzer
  # This class describes methods for application config files generator
  class ConfigGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: 'custom.yml', destination: 'config/custom.yml' },
          { source: 'default.yml', destination: 'config/default.yml' }
        ]
      }
    end

    protected

    def banner
      <<-EOF
  * Config files generation ...
      EOF
    end
  end
end
