module Howitzer
  module Meta
    class Entry
      attr_reader :context

      def initialize(context)
        @context = context
      end

      def elements
        elements_names = context.private_methods
                                .select { |el| el[/_element$/] }.delete_if { |el| el.to_s.start_with?('wait') }
        elements_names.map! { |el| Meta::Element.new(el.to_s.gsub('_element', ''), @context) }
      end

      def element(name)
        elements.find { |el| el.name == name }
      end

      def sections
        sections_names = context.public_methods
                                .select { |el| el[/_section$/] }.delete_if { |el| el.to_s.start_with?('wait') }
        sections_names.map! { |el| Meta::Section.new(el.to_s.gsub('_section', ''), @context) }
      end

      def section(name)
        sections.find { |el| el.name == name }
      end

      def iframes
        iframes_names = context.public_methods
                               .select { |el| el[/_iframe$/] }.delete_if { |el| el.to_s.start_with?('wait') }
        iframes_names.map! { |el| Meta::Iframe.new(el.to_s.gsub('_iframe', ''), @context) }
      end

      def iframe(name)
        iframes.find { |el| el.name == name }
      end
    end
  end
end
