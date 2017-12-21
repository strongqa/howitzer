module Howitzer
  module Meta
    class Section
      attr_reader :name, :context

      def initialize(name, context)
        @name = name
        @context = context
      end

      def capybara_elements
        context.send("#{name}_sections")
      end

      def capybara_element
        section = context.send("#{name}_sections").first
        section.nil? ? nil : section.capybara_context
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
