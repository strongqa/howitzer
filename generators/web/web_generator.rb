require_relative '../base_generator'

module Howitzer
  # This class responsible for page object pattern generation
  class WebGenerator < BaseGenerator
    def manifest
      { files:
        [
          { source: 'example_page.rb', destination: 'web/pages/example_page.rb' },
          { source: 'menu_section.rb', destination: 'web/sections/menu_section.rb' }
        ] }
    end

    protected

    def banner
      <<-MSG
  * PageOriented pattern structure generation ...
      MSG
    end
  end
end
