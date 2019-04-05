require 'howitzer/web/capybara_context_holder'
module Howitzer
  module Web
    # This module combines iframe dsl methods
    module IframeDsl
      include CapybaraContextHolder

      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end

      private

      def iframe_element_selector(args, params)
        args = convert_iframe_arguments(args, params)
        case args[0]
        when String, Hash
          [:frame, *args]
        when Integer
          idx = args.shift
          ["iframe:nth-of-type(#{idx + 1})", *args]
        else
          args
        end
      end

      def convert_iframe_arguments(args, params)
        new_args = args.deep_dup
        hash = new_args.pop.merge(params) if new_args.last.is_a?(Hash)
        new_args << hash if hash.present?
        new_args
      end

      # This module holds frame dsl class methods
      module ClassMethods
        protected

        # Creates a group of methods to interact with described HTML frame on page
        # @note This method generates following dynamic methods:
        #
        #   <b><em>frame_name</em>_iframe</b> - equals capybara #within_frame(...) method
        #
        #   <b>has_<em>frame_name</em>_iframe?</b> - equals capybara #has_selector(...) method
        #
        #   <b>has_no_<em>frame_name</em>_iframe?</b> - equals capybara #has_no_selector(...) method
        # @param name [Symbol, String] an unique iframe name
        # @param args [Array] original Capybara arguments. For details, see `Capybara::Session#within_frame`.
        # @raise [NameError] if page class can not be found
        # @example Using in a page class
        #   class FbPage < Howitzer::Web::Page
        #     element :like, :xpath, ".//*[text()='Like']"
        #     def like
        #       like_element.click
        #     end
        #
        #     def liked?
        #       #some code here
        #     end
        #   end
        #
        #   module Utils
        #     class GroupFbPage < Howitzer::Web::Page
        #     end
        #   end
        #
        #   class HomePage < Howitzer::Web::Page
        #     iframe :fb, 1
        #
        #    # frame with explicit class declaration
        #    # iframe :fb, FbPage, 1
        #
        #    # frame with namespace
        #     iframe :utils_group_fb
        #   end
        #
        #   HomePage.on do
        #     fb_iframe do |frame|
        #       frame.like
        #       expect(frame).to be_liked
        #     end
        #   end
        #   HomePage.on { is_expected.to have_fb_iframe }
        # @!visibility public

        def iframe(name, *args)
          raise ArgumentError, 'iframe selector arguments must be specified' if args.blank?

          klass = args.first.is_a?(Class) ? args.shift : find_matching_class(name)
          raise NameError, "class can not be found for #{name} iframe" if klass.blank?

          define_iframe(klass, name, args)
          define_has_iframe(name, args)
          define_has_no_iframe(name, args)
        end

        private

        def define_iframe(klass, name, args)
          define_method "#{name}_iframe" do |**params, &block|
            capybara_context.within_frame(*convert_iframe_arguments(args, params)) do
              klass.displayed?
              block.call klass.instance
            end
          end
        end

        def define_has_iframe(name, args)
          define_method("has_#{name}_iframe?") do |**params|
            capybara_context.has_selector?(*iframe_element_selector(args, params))
          end
        end

        def define_has_no_iframe(name, args)
          define_method("has_no_#{name}_iframe?") do |**params|
            capybara_context.has_no_selector?(*iframe_element_selector(args, params))
          end
        end

        def find_matching_class(name)
          Howitzer::Web::Page.descendants.select { |el| el.name.underscore.tr('/', '_') == "#{name}_page" }
                             .max_by { |el| el.name.count('::') }
        end
      end
    end
  end
end
