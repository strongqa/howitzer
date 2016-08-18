require_relative '../base_generator'

module Howitzer
  # This class responsible for project root files generation
  class RootGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: '.gitignore', destination: '.gitignore' },
          { source: '.rubocop.yml', destination: '.rubocop.yml' },
          { source: 'Rakefile', destination: 'Rakefile' }
        ],
        templates:
        [
          { source: 'Gemfile.erb', destination: 'Gemfile' }
        ] }
    end

    protected

    def banner
      <<-EOF
  * Root files generation ...
      EOF
    end
  end
end
