require 'rbconfig'

class TasksGenerator < RubiGen::Base
  def initialize(runtime_args, runtime_options = {})
    super
    @destination_root = File.expand_path('tasks')
  end

  def manifest
    record do |m|
      m.directory ''
      m.template 'cucumber.rake', 'cucumber.rake'
    end
  end

  protected
  def banner
    <<-EOF
    Creates RAKE tasks folder and file.
    EOF
  end
end