require 'howitzer/web/capybara_methods_proxy'
require 'howitzer/web/element_dsl'
require 'howitzer/web/iframe_dsl'
require 'howitzer/web/section_dsl'

module Howitzer
  module Web
    # This class holds base functinality for sections
    class BaseSection
      include ElementDsl
      include SectionDsl
      include IframeDsl
      include CapybaraMethodsProxy

      attr_reader :parent

      class << self
        attr_reader :default_finder_args, :default_finder_options
      end

      def initialize(parent, context)
        @parent = parent
        capybara_scopes << context
      end
    end
  end
end
