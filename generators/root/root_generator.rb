require_relative '../base_generator'

module Howitzer
  class RootGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: '.gitignore', destination: '.gitignore'},
          { source: 'Gemfile', destination: 'Gemfile'},
          { source: 'Rakefile', destination: 'Rakefile'},
          { source: 'boot.rb', destination: 'boot.rb'}
        ]
      }
    end

    protected
    def banner
      <<-EOF
      Creates root config files.
      EOF
    end
  end
end