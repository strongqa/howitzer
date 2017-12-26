module Howitzer
  module Meta
    # This class represents iframe entity within howitzer meta information interface
    class Iframe
      attr_reader :name, :context

      def initialize(name, context)
        @name = name
        @context = context
      end

      # Finds all instances of iframe on the page and returns them as array of capybara elements
      # @return [Array]
      def capybara_elements
        block = proc do |frame|
          @site_value = frame.class.send(:site_value)
        end
        context.send("#{name}_iframe", &block)
        context.capybara_context.all("iframe[src='#{@site_value}']")
      end

      # Finds iframe on the page and returns as a capybara element
      # @param wait [Integer] wait time for element search
      # @return [Capybara::Node::Element, nil]
      def capybara_element(wait: 0)
        block = proc do |frame|
          @site_value = frame.class.send(:site_value)
        end
        context.send("#{name}_iframe", &block)
        context.capybara_context.find("iframe[src='#{@site_value}']", match: :first, wait: wait)
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
