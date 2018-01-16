module Howitzer
  module Meta
    # This class provides access to meta information entities
    class Entry
      attr_reader :context

      # Creates new meta entry instance for the page which provides access to elements, iframes and sections
      # @param context [Howitzer::Web::Page] page for which entry is created
      def initialize(context)
        @context = context
      end

      # Returns array of elements
      # @return [Array]
      def elements
        @elements ||= context
                      .private_methods
                      .grep(/\A(?!wait_)\w+_element\z/)
                      .map { |el| Meta::Element.new(el.to_s.gsub('_element', ''), context) }
      end

      # Finds element by name
      # @param name [String, Symbol] element name
      # @return [Meta::Element]
      def element(name)
        elements.find { |el| el.name == name.to_s }
      end

      # Returns array of sections
      # @return [Array]
      def sections
        @sections ||= context
                      .public_methods
                      .grep(/\A(?!wait_)\w+_section$\z/)
                      .map { |el| Meta::Section.new(el.to_s.gsub('_section', ''), context) }
      end

      # Finds section by name
      # @param name [String, Symbol] section name
      # @return [Meta::Section]
      def section(name)
        sections.find { |el| el.name == name.to_s }
      end

      # Returns array of iframes
      # @return [Array]
      def iframes
        @iframes ||= context
                     .public_methods
                     .grep(/\A(?!wait_)\w+_iframe$\z/)
                     .map { |el| Meta::Iframe.new(el.to_s.gsub('_iframe', ''), context) }
      end

      # Finds iframe by name
      # @param name [String, Symbol] iframe name
      # @return [Meta::Iframe]
      def iframe(name)
        iframes.find { |el| el.name == name.to_s }
      end
    end
  end
end
