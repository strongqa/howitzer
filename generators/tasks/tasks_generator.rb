require 'rbconfig'

class TasksGenerator < RubiGen::Base
  def manifest
    record do |m|
      m.directory 'tasks'
      m.template 'common.rake', '/tasks/common.rake'
    end
  end

  protected
  def banner
    <<-EOF
    Creates RAKE tasks folder and file.
    EOF
  end
end