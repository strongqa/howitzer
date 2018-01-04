require 'howitzer/meta/base'

module Howitzer
  module Meta
    # This class represents section entity within howitzer meta information interface
    class Section < Base
      attr_reader :name, :context

      def initialize(name, context)
        @name = name
        @context = context
      end

      # Finds all instances of section on the page and returns them as array of capybara elements
      # @return [Array]
      def capybara_elements
        context.send("#{name}_sections").map(&:capybara_context)
      end

      # Finds section on the page and returns as a capybara element
      # @return [Capybara::Node::Element, nil]
      def capybara_element
        section = context.send("#{name}_sections").first
        section.nil? ? nil : section.capybara_context
      end
    end
  end
end
