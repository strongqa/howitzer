module Howitzer
  module Meta
    # This class represents element entity within howitzer meta information interface
    class Element
      attr_reader :name, :context

      include Howitzer::Meta::Actions
      # Creates new meta element with meta information and utility actions
      # @param name [String] name of the element
      # @param context [Howitzer::Web::Page] page element belongs to
      def initialize(name, context)
        @name = name
        @context = context
      end

      # Finds all instances of element on the page and returns them as array of capybara elements
      # @param *args [Array] arguments for elements described with lambda locators
      # @return [Array]
      def capybara_elements(*args)
        context.send("#{name}_elements", *args)
      end

      # Finds element on the page and returns as a capybara element
      # @param *args [Array] arguments for elements described with lambda locators
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
