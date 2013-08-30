require_relative '../base_generator'

module Howitzer
  class PagesGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: 'example_page.rb', destination: 'pages/example_page.rb'},
          { source: 'example_menu.rb', destination: 'pages/example_menu.rb'}
        ]
      }
    end

    protected
    def banner
      <<-EOS
      Creates PageOriented pattern structure
      EOS
    end
  end
end