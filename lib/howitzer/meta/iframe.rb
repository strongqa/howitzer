require 'howitzer/meta/base'

module Howitzer
  module Meta
    # This class represents iframe entity within howitzer meta information interface
    class Iframe < Base
      attr_reader :name, :context

      def initialize(name, context)
        @name = name
        @context = context
      end

      # Finds all instances of iframe on the page and returns them as array of capybara elements
      # @return [Array]
      def capybara_elements
        context.send("#{name}_iframe") do |frame|
          @site_value = frame.class.send(:site_value)
        end
        context.capybara_context.all("iframe[src='#{@site_value}']")
      end

      # Finds iframe on the page and returns as a capybara element
      # @param wait [Integer] wait time for element search
      # @return [Capybara::Node::Element, nil]
      def capybara_element(wait: 0)
        context.send("#{name}_iframe") do |frame|
          @site_value = frame.class.send(:site_value)
        end
        context.capybara_context.find("iframe[src='#{@site_value}']", match: :first, wait: wait)
      rescue Capybara::ElementNotFound
        nil
      end
    end
  end
end
