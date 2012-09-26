require 'rbconfig'

class ConfigGenerator < RubiGen::Base
  def initialize(runtime_args, runtime_options = {})
    super
    @destination_root = File.expand_path('config')
  end

  def manifest
    record do |m|
      m.directory ''
      m.template 'custom.yml', 'config/custom.yml'
      m.template 'default.yml', 'config/default.yml'
      m.template 'cucumber.yml', 'config/cucumber.yml'
    end
  end

  protected
  def banner
    <<-EOF
    Creates config files.
    EOF
  end
end