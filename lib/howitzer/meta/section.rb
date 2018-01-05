module Howitzer
  module Meta
    # This class represents section entity within howitzer meta information interface
    class Section
      attr_reader :name, :context

      include Howitzer::Meta::Actions

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
        section.try(:capybara_context)
      end
    end
  end
end
