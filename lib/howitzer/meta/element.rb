module Howitzer
  module Meta
    class Element
      attr_reader :name, :context

      def initialize(name, context)
        @name = name
        @context = context
      end

      def capybara_elements
        context.send("#{name}_elements")
      end

      def capybara_element(wait: 0)
        context.send("#{name}_element", match: :first, wait: wait)
      rescue Capybara::ElementNotFound
        nil
      end

      def highlight
        context.execute_script("document.evaluate('#{xpath}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE,"\
                               ' null).singleNodeValue.style.border = "thick solid red"')
      end

      def xpath
        capybara_element.path
      end
    end
  end
end
