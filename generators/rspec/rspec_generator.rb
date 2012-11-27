require 'rbconfig'

class RspecGenerator < RubiGen::Base
  def initialize(runtime_args, runtime_options = {})
    super
    @destination_root = File.expand_path('spec')
  end

  def manifest
    record do |m|
      m.directory ''
      m.template 'spec_helper.rb', 'spec_helper.rb'
      m.template 'example_spec.rb', 'example_spec.rb'
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