module Howitzer
  module Meta
    # This class represents iframe entity within howitzer meta information interface
    class Iframe
      attr_reader :name, :context

      def initialize(name, context)
        @name = name
        @context = context
      end

      def capybara_elements
        block = proc do |frame|
          @site_value = frame.class.send(:site_value)
        end
        context.send("#{name}_iframe", &block)
        context.capybara_context.all("iframe[src='#{@site_value}']")
      end

      def capybara_element(wait: 0)
        block = proc do |frame|
          @site_value = frame.class.send(:site_value)
        end
        context.send("#{name}_iframe", &block)
        context.capybara_context.find("iframe[src='#{@site_value}']", match: :first, wait: wait)
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
