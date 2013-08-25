require 'rbconfig'

class PagesGenerator < RubiGen::Base
  def manifest
    record do |m|
      m.directory 'pages'
      m.template 'example_page.rb', '/pages/example_page.rb'
      m.template 'example_menu.rb', '/pages/example_menu.rb'
    end
  end

  protected
  def banner
    <<-EOS
    Creates PageOriented pattern structure
    EOS
  end
end