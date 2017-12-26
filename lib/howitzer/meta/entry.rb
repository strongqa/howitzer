module Howitzer
  module Meta
    # This class provides access to meta information entities
    class Entry
      attr_reader :context

      def initialize(context)
        @context = context
      end

      # Returns array of elements
      # @return [Array]
      def elements
        elements_names = context.private_methods
                                .select { |el| el[/_element$/] }.delete_if { |el| el.to_s.start_with?('wait') }
        elements_names.map! { |el| Meta::Element.new(el.to_s.gsub('_element', ''), @context) }
      end

      # Finds element by name
      # @param name [String] element name
      # @return [Meta::Element]
      def element(name)
        elements.find { |el| el.name == name }
      end

      # Returns array of sections
      # @return [Array]
      def sections
        sections_names = context.public_methods
                                .select { |el| el[/_section$/] }.delete_if { |el| el.to_s.start_with?('wait') }
        sections_names.map! { |el| Meta::Section.new(el.to_s.gsub('_section', ''), @context) }
      end

      # Finds section by name
      # @param name [String] section name
      # @return [Meta::Section]
      def section(name)
        sections.find { |el| el.name == name }
      end

      # Returns array of iframes
      # @return [Array]
      def iframes
        iframes_names = context.public_methods
                               .select { |el| el[/_iframe$/] }.delete_if { |el| el.to_s.start_with?('wait') }
        iframes_names.map! { |el| Meta::Iframe.new(el.to_s.gsub('_iframe', ''), @context) }
      end

      # Finds iframe by name
      # @param name [String] iframe name
      # @return [Meta::Iframe]
      def iframe(name)
        iframes.find { |el| el.name == name }
      end
    end
  end
end
