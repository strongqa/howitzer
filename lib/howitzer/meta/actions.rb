module Howitzer
  module Meta
    # Module with utility actions for elements
    module Actions
      # Highlights element with red border on the page
      # @param *args [Array] arguments for elements described with lambda locators and
      # inline options for element/s as a hash
      def highlight(*args)
        if xpath(*args).blank?
          Howitzer::Log.debug("Element #{name} not found on the page")
          return
        end
        context.execute_script("document.evaluate('#{escape(xpath(*args))}', document, null, " \
                          'XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.style.border = "thick solid red"')
      end

      # Returns xpath for the element
      # @param *args [Array] arguments for elements described with lambda locators and
      # inline options for element/s as a hash
      # @return [String, nil]
      def xpath(*args)
        capybara_element(*args).try(:path)
      end

      private

      def escape(xpath)
        xpath.gsub(/(['"])/, '\\\\\\1')
      end

      def convert_args(args)
        new_args = []
        params = args.reject { |v| new_args << v if v.is_a?(Hash) }
        [params, new_args.reduce(:merge)].flatten
      end
    end
  end
end
