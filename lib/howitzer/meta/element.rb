module Howitzer
  module Meta
    # This class represents element entity within howitzer meta information interface
    class Element < Base
      attr_reader :name, :context

      def initialize(name, context)
        @name = name
        @context = context
      end

      # Finds all instances of element on the page and returns them as array of capybara elements
      # @return [Array]
      def capybara_elements
        context.send("#{name}_elements")
      end

      # Finds element on the page and returns as a capybara element
      # @param *args [Array] arguments for elements with dynamic content
      # @param wait [Integer] wait time for element search
      # @return [Capybara::Node::Element, nil]
      def capybara_element(*args, wait: 0)
        context.send("#{name}_element", *args, match: :first, wait: wait)
      rescue Capybara::ElementNotFound
        nil
      end
    end
  end
end
