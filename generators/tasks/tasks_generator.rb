require_relative '../base_generator'

module Howitzer
  class TasksGenerator < BaseGenerator
    def manifest
      { files: [ source: 'common.rake', destination: 'tasks/common.rake' ] }
    end

    protected
    def banner
      <<-EOF
      Creates RAKE tasks folder and file.
      EOF
    end
  end
end