require 'rbconfig'

class EmailsGenerator < RubiGen::Base
  def manifest
    record do |m|
      m.directory 'emails'
      m.template 'example_email.rb', '/emails/example_email.rb'
    end
  end

  protected
  def banner
    <<-EOS
Creates a simple email class."
    EOS
  end
end