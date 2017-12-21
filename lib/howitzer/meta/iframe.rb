module Howitzer
  module Meta
    class Iframe
      attr_reader :name, :context

      def initialize(name, context)
        @name = name
        @context = context
      end

      def capybara_elements
        context.send("#{name}_iframes")
      end

      def capybara_element(wait: 0)
        context.send("#{name}_iframe", match: :first, wait: wait)
      rescue Capybara::ElementNotFound
        nil
      end

      def hightlight
        context.execute_script("document.evaluate('#{xpath}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE,"\
                                                  ' null).singleNodeValue.style.border = "thick solid red"')
      end

      def xpath
        capybara_element.path
      end
    end
  end
end
