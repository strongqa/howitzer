require 'rbconfig'

class RootGenerator < RubiGen::Base
  def manifest
    record do |m|
      m.directory ''
      m.template '.gitignore', '.gitignore'
      m.template 'Gemfile', 'Gemfile'
      m.template 'Rakefile', 'Rakefile'
      m.template 'boot.rb', 'boot.rb'
    end
  end

  protected
  def banner
    <<-EOF
    Creates root config files.
    EOF
  end
end