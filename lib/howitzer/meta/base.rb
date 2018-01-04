module Howitzer
  module Meta
    # Base class for meta elements, contains utility methods
    class Base
      # Highlights element with red border on the page
      def highlight
        if xpath.blank?
          Howitzer::Log.info("Element #{@name} not found on the page")
          return
        end
        context.execute_script("document.evaluate('#{escape(xpath)}', document, null, " \
                          'XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.style.border = "thick solid red"')
      end

      # Returns xpath for the element
      # @return [String, nil]
      def xpath
        capybara_element.try(:path)
      end

      private

      def escape(xpath)
        xpath.gsub("'", '\\\\\'').gsub('"', '\"')
      end
    end
  end
end
