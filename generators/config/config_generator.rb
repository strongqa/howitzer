require 'rbconfig'

class ConfigGenerator < RubiGen::Base
  def manifest
    record do |m|
      m.directory 'config'
      m.template 'custom.yml', '/config/custom.yml'
      m.template 'default.yml', '/config/default.yml'
    end
  end

  protected
  def banner
    <<-EOF
    Creates config files.
    EOF
  end
end