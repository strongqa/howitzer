require_relative '../base_generator'
module Howitzer
  class ConfigGenerator < BaseGenerator
      def manifest
        { files:
          [
            { source: 'custom.yml', destination: 'config/custom.yml'},
            { source: 'default.yml', destination: 'config/default.yml'}
          ]
        }
    end

    protected
    def banner
      <<-EOF
      Creates config files.
      EOF
    end
  end
end