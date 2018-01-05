module Howitzer
  module Meta
    # Module with utility actions for elements
    module Actions
      # Highlights element with red border on the page
      def highlight(*args)
        if xpath(*args).blank?
          Howitzer::Log.debug("Element #{name} not found on the page")
          return
        end
        context.execute_script("document.evaluate('#{escape(xpath(*args))}', document, null, " \
                          'XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.style.border = "thick solid red"')
      end

      # Returns xpath for the element
      # @return [String, nil]
      def xpath(*args)
        capybara_element(*args).try(:path)
      end

      private

      def escape(xpath)
        xpath.gsub(/(['"])/, '\\\\\\1')
      end
    end
  end
end
