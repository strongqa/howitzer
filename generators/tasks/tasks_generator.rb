require_relative '../base_generator'

module Howitzer
  # This class responsible for rake tasks generation
  class TasksGenerator < BaseGenerator
    def manifest
      { files: [source: 'common.rake', destination: 'tasks/common.rake'] }
    end

    protected

    def banner
      <<-EOF
  * Base rake task generation ...
      EOF
    end
  end
end
