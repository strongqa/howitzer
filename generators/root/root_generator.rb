require_relative '../base_generator'

module Howitzer
  # This class combines methods for application root files generator
  class RootGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: '.gitignore', destination: '.gitignore' },
          { source: 'Rakefile', destination: 'Rakefile' },
          { source: 'boot.rb', destination: 'boot.rb' }
        ],
        templates:
        [
          { source: 'Gemfile.erb', destination: 'Gemfile' }
        ]
      }
    end

    protected

    def banner
      <<-EOF
  * Root files generation ...
      EOF
    end
  end
end
