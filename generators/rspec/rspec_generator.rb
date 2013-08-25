require 'rbconfig'

class RspecGenerator < RubiGen::Base
  def manifest
    record do |m|
      m.directory 'spec'
      m.directory '../tasks'
      m.template 'spec_helper.rb', '/spec/spec_helper.rb'
      m.template 'example_spec.rb', '/spec/example_spec.rb'
      m.template 'rspec.rake', '../tasks/rspec.rake'
    end
  end

  protected
  def banner
    <<-EOS
    Integrates RSpec to the framework.
    EOS
  end

end