require 'rbconfig'

class EmailsGenerator < RubiGen::Base

  def initialize(runtime_args, runtime_options = {})
    super
    @destination_root = File.expand_path('emails')
  end

  def manifest
    record do |m|
      m.directory ''
      m.template 'example_email.rb', 'example_email.rb'
    end
  end

  protected
  def banner
    <<-EOS
Creates a simple email class."
    EOS
  end
end