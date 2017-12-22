module Howitzer
  module Meta
    # This class represents section entity within howitzer meta information interface
    class Section
      attr_reader :name, :context

      def initialize(name, context)
        @name = name
        @context = context
      end

      def capybara_elements
        context.send("#{name}_sections").map(&:capybara_context)
      end

      def capybara_element
        section = context.send("#{name}_sections").first
        section.nil? ? nil : section.capybara_context
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
