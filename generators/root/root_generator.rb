require_relative '../base_generator'

module Howitzer
  class RootGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: '.gitignore', destination: '.gitignore'},
          { source: 'Rakefile', destination: 'Rakefile'},
          { source: 'boot.rb', destination: 'boot.rb'}
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