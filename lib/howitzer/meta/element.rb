module Howitzer
  module Meta
    # This class represents element entity within howitzer meta information interface
    class Element
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
