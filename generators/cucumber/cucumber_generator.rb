require 'rbconfig'

class CucumberGenerator < RubiGen::Base
  def initialize(runtime_args, runtime_options = {})
    super
    @destination_root = File.expand_path('features')
  end

  def manifest
    record do |m|
      m.directory ''
      BASEDIRS.each{|path| m.directory path}
      m.template 'common_steps.rb', 'step_definitions/common_steps.rb'
      m.template 'env.rb', 'support/env.rb'
      m.template 'example.feature', 'example.feature'
    end
  end

  protected
  def banner
    <<-EOS
    Creates cucumber features structure.
    EOS
  end

  BASEDIRS = %w(
    step_definitions
    support
  )
end