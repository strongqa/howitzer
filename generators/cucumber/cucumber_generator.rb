require_relative '../base_generator'

module Howitzer
  # This class responsible for Cucumber based files generation
  class CucumberGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: 'common_steps.rb', destination: 'features/step_definitions/common_steps.rb' },
          { source: 'env.rb', destination: 'features/support/env.rb' },
          { source: 'hooks.rb', destination: 'features/support/hooks.rb' },
          { source: 'transformers.rb', destination: 'features/support/transformers.rb' },
          { source: 'example.feature', destination: 'features/example.feature' },
          { source: 'cucumber.rake', destination: 'tasks/cucumber.rake' },
          { source: 'cuke_sniffer.rake', destination: 'tasks/cuke_sniffer.rake' }
        ] }
    end

    protected

    def banner
      <<-EOS
  * Cucumber integration to the framework ...
      EOS
    end
  end
end
