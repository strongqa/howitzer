require 'howitzer/web/base_section'
require 'howitzer/meta'

module Howitzer
  module Web
    # This class uses for named sections which possible to reuse in different pages
    class Section < BaseSection
      # Provides access to meta information about entities in section
      # @return [Meta::Entry]
      def meta
        @meta ||= Meta::Entry.new(self)
      end

      class << self
        protected

        # DSL method which specifies section container selector represented by HTML element.
        # Any elements described in sections will start in this HTML element.
        # @param args [Array] original Capybara arguments. For details, see `Capybara::Node::Finders#all.
        # @param options [Array] original Capybara options. For details, see `Capybara::Node::Finders#all.
        # @raise [ArgumentError] if no arguments were passed
        # @example
        #   class MenuSection < Howitzer::Web::Section
        #     me :xpath, ".//*[@id='panel']",
        #   end
        # @!visibility public

        def me(*args, **options)
          raise ArgumentError, 'Finder arguments are missing' if args.blank?

          @default_finder_args = args
          @default_finder_options = options
          self
        end
      end
    end
  end
end
