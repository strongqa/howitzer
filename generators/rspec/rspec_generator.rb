require_relative '../base_generator'

module Howitzer
  class RspecGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: 'spec_helper.rb', destination: 'spec/spec_helper.rb'},
          { source: 'example_spec.rb', destination: 'spec/example_spec.rb'},
          { source: 'rspec.rake', destination: 'tasks/rspec.rake'}
        ]
      }
    end

    protected
    def banner
      <<-EOS
  * RSpec integration to the framework ...
      EOS
    end

  end
end