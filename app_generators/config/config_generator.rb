require 'rbconfig'

class ConfigGenerator < RubiGen::Base
  def initialize(runtime_args, runtime_options = {})
    super
    @destination_root = File.expand_path('')
  end

  def manifest
    record do |m|
      m.directory ''
      BASEDIRS.each{|path| m.directory path}
      m.template 'custom.yml', 'config/custom.yml'
      m.template 'default.yml', 'config/default.yml'
      m.template 'cucumber.yml', 'config/cucumber.yml'
      m.template '.gitignore', '.gitignore'
      m.template 'Gemfile', 'Gemfile'
      m.template 'Rakefile', 'Rakefile'
    end
  end

  protected
  def banner
    <<-EOF
    Creates config files.
    EOF
  end

  BASEDIRS = %w(
    config
  )
end