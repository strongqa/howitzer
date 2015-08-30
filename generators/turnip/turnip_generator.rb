require_relative '../base_generator'

module Howitzer
  class TurnipGenerator < BaseGenerator
    def manifest
      { files:
            [
                { source: '.rspec', destination: '.rspec'},
                { source: 'spec_helper.rb', destination: 'spec/spec_helper.rb'},
                { source: 'turnip_helper.rb', destination: 'spec/turnip_helper.rb'},
                { source: 'example.feature', destination: 'spec/acceptance/example.feature'},
                { source: 'common_steps.rb', destination: 'spec/steps/common_steps.rb'}
            ]
      }
    end

    protected
    def banner
      <<-EOS
  * Turnip integration to the framework ...
      EOS
    end
  end
end