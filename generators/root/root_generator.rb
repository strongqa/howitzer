require_relative '../base_generator'

module Howitzer
  # This class responsible for project root files generation
  class RootGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: '.gitignore', destination: '.gitignore' },
          { source: '.dockerignore', destination: '.dockerignore' },
          { source: 'Dockerfile', destination: 'Dockerfile' },
          { source: 'Rakefile', destination: 'Rakefile' }
        ],
        templates:
        [
          { source: '.rubocop.yml.erb', destination: '.rubocop.yml' },
          { source: 'docker-compose.yml.erb', destination: 'docker-compose.yml' },
          { source: 'Gemfile.erb', destination: 'Gemfile' },
          { source: 'README.md.erb', destination: 'README.md' }
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
