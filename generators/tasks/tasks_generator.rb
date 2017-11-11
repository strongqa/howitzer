require_relative '../base_generator'

module Howitzer
  # This class responsible for rake tasks generation
  class TasksGenerator < BaseGenerator
    def manifest
      { files: [source: 'common.rake', destination: 'tasks/common.rake'] }
    end

    protected

    def banner
      <<-MSG
  * Base rake task generation ...
      MSG
    end
  end
end
