require_relative '../base_generator'

module Howitzer
  class CucumberGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: 'common_steps.rb', destination: 'features/step_definitions/common_steps.rb'},
          { source: 'env.rb', destination: 'features/support/env.rb'},
          { source: 'transformers.rb', destination: 'features/support/transformers.rb'},
          { source: 'example.feature', destination: 'features/example.feature'},
          { source: 'cucumber.rake', destination: 'tasks/cucumber.rake'},
          { source: 'cucumber.yml', destination: 'config/cucumber.yml'}
        ]
      }
    end

    protected
    def banner
      <<-EOS
      Integrates Cucumber to the framework
      EOS
    end
  end
end