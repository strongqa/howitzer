module Howitzer
  module Meta
    # This class represents iframe entity within howitzer meta information interface
    class Iframe
      attr_reader :name, :context

      include Howitzer::Meta::Actions

      def initialize(name, context)
        @name = name
        @context = context
      end

      # Finds all instances of iframe on the page and returns them as array of capybara elements
      # @return [Array]
      def capybara_elements
        context.capybara_context.all("iframe[src='#{site_value}']")
      end

      # Finds iframe on the page and returns as a capybara element
      # @param wait [Integer] wait time for element search
      # @return [Capybara::Node::Element, nil]
      def capybara_element(wait: 0)
        context.capybara_context.find("iframe[src='#{site_value}']", match: :first, wait: wait)
      rescue Capybara::ElementNotFound
        nil
      end

      # Returns url value for iframe
      # @return [String]
      def site_value
        return @site_value if @site_value.present?
        context.send("#{name}_iframe") { |frame| @site_value = frame.class.send(:site_value) }
      end
    end
  end
end
