module Howitzer
  module Meta
    # This class represents section entity within howitzer meta information interface
    class Section
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

      # Highlights element with red border on the page
      def highlight
        if xpath.blank?
          Howitzer::Log.info("Element #{@name} not found on the page")
          return
        end
        context.execute_script("document.evaluate('#{xpath}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE,"\
                               ' null).singleNodeValue.style.border = "thick solid red"')
      end

      # Returns xpath for the element
      # @return [String, nil]
      def xpath
        element = capybara_element
        element.path unless element.blank?
      end
    end
  end
end
