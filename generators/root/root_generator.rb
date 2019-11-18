require_relative '../base_generator'

module Howitzer
  # This class responsible for project root files generation
  class RootGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: '.gitignore', destination: '.gitignore' },
          { source: 'Rakefile', destination: 'Rakefile' }
        ],
        templates:
        [
          { source: '.rubocop.yml.erb', destination: '.rubocop.yml' },
          { source: 'Gemfile.erb', destination: 'Gemfile' }
        ] }
    end

    protected

    def banner
      <<-MSG
  * Root files generation ...
      MSG
    end
  end
end
