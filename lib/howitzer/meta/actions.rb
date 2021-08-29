module Howitzer
  module Meta
    # Module with utility actions for elements
    module Actions
      # Highlights element with red border on the page
      # @param args [Array] arguments for elements described with lambda locators
      # @param options [Hash] original Capybara options. For details, see `Capybara::Node::Finders#all`
      def highlight(*args, **options)
        if xpath(*args, **options).blank?
          Howitzer::Log.debug("Element #{name} not found on the page")
          return
        end
        element = escape(xpath(*args, **options))
        context.execute_script(
          "document.evaluate('#{element}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null)." \
          'singleNodeValue.style.border = "thick solid red"'
        )
      end

      # Returns xpath for the element
      # @param args [Array] arguments for elements described with lambda locators
      # @param options [Hash] original Capybara options. For details, see `Capybara::Node::Finders#all`
      # @return [String, nil]
      def xpath(*args, **options)
        capybara_element(*args, **options).try(:path)
      end

      private

      def escape(xpath)
        xpath.gsub(/(['"])/, '\\\\\\1')
      end
    end
  end
end
