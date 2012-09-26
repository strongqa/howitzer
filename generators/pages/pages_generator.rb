require 'rbconfig'

class PagesGenerator < RubiGen::Base
  def initialize(runtime_args, runtime_options = {})
    super
    @destination_root = File.expand_path('pages')
  end

  def manifest
    record do |m|
      m.directory ''
      m.template 'example_page.rb', 'example_page.rb'
      m.template 'example_menu.rb', 'example_menu.rb'
    end
  end

  protected
  def banner
    <<-EOS
    Creates PageOriented pattern structure
    EOS
  end
end