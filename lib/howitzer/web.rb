module Howitzer
  # This class holds everything related with web GUI
  module Web
    # Execute the given block within a given session
    # @param name [String, Symbol] a session name

    def self.within_session(name, &block)
      Capybara.using_session(name, &block)
    end

    # @return [String, nil] a current session name

    def self.current_session_name
      Capybara.session_name
    end

    # Set a session to use
    # @param value [String, Symbol] a session name

    def self.current_session_name=(value)
      Capybara.session_name = value
    end
  end
end
require 'howitzer/web/page_validator'
require 'howitzer/web/element_dsl'
require 'howitzer/web/section_dsl'
require 'howitzer/web/section'
require 'howitzer/web/page'
require 'howitzer/web/blank_page'
