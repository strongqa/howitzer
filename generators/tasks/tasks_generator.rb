require_relative '../base_generator'

module Howitzer
  # This class combines methods for application task generator
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
