require 'howitzer/web/capybara_context_holder'
module Howitzer
  module Web
    # This module combines element dsl methods
    module ElementDsl
      # This module holds element helper methods
      module Helpers
        private

        def lambda_args(*args, **keyword_args)
          {
            lambda_args: {
              args: args,
              keyword_args: keyword_args
            }
          }
        end
      end

      include CapybaraContextHolder
      include Helpers

      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end

      def convert_arguments(args, params) # rubocop:disable Metrics/AbcSize
        args.map do |el|
          next(el) unless el.is_a?(Proc)

          lambda_args = params.first.is_a?(Hash) && params.first[:lambda_args]
          if lambda_args
            if lambda_args[:keyword_args].present?
              el.call(*lambda_args[:args], **lambda_args[:keyword_args])
            else
              el.call(*lambda_args[:args])
            end
          else
            puts "WARNING! Passing lambda arguments with element options is deprecated.\n" \
                 "Please use 'lambda_args' method, for example: foo_element(lambda_args(title: 'Example'), wait: 10)"
            el.call(*params.shift(el.arity))
          end
        end
      end

      # This module holds element dsl methods
      module ClassMethods
        include Helpers

        protected

        # Creates a group of methods to interact with described HTML element(s) on page
        # @note This method generates following dynamic methods:
        #
        #   <b><em>element_name</em>_element</b> - equals capybara #find(...) method
        #
        #   <b><em>element_name</em>_elements</b> - equals capybara #all(...) method
        #
        #   <b><em>element_name</em>_elements.first</b> - equals capybara #first(...) method
        #
        #   <b>wait_for_<em>element_name</em>_element</b> - equals capybara #find(...) method but returns nil
        #
        #   <b>within_<em>element_name</em>_element</b> - equals capybara #within(...) method
        #
        #   <b>has_<em>element_name</em>_element?</b> - equals capybara #has_selector(...) method
        #
        #   <b>has_no_<em>element_name</em>_element?</b> - equals capybara #has_no_selector(...) method
        # @param name [Symbol, String] an unique element name
        # @param args [Array] original Capybara arguments. For details, see `Capybara::Node::Finders#all`.
        # @param options [Hash] original Capybara options. For details, see `Capybara::Node::Finders#all`.
        # @example Using in a page class
        #   class HomePage < Howitzer::Web::Page
        #     element :top_panel, '.top'
        #     element :bottom_panel, '.bottom'
        #     element :new_button, :xpath, ".//*[@name='New']"
        #
        #     def press_top_new_button
        #       within_top_panel_element do
        #         new_button_element.click
        #       end
        #     end
        #
        #     def press_bottom_new_button
        #       within_bottom_panel_element do
        #         new_button_element.click
        #       end
        #     end
        #   end
        #
        #   HomePage.on do
        #     is_expected.to have_top_panel_element
        #     press_top_new_element
        #     is_expected.to have_no_new_button_element(match: :first)
        #   end
        # @example Using in a section class
        #   class MenuSection < Howitzer::Web::Section
        #     me '.main-menu'
        #     element :menu_item, '.item'
        #
        #     def menu_items
        #       menu_item_elements.map(&:text)
        #     end
        #   end
        # @raise [BadElementParamsError] if wrong element arguments
        # @!visibility public

        def element(name, *args, **options)
          validate_arguments!(args)
          define_element(name, args, options)
          define_elements(name, args, options)
          define_wait_for_element(name, args, options)
          define_within_element(name, args, options)
          define_has_element(name, args, options)
          define_has_no_element(name, args, options)
        end

        private

        def validate_arguments!(args)
          return unless args.map(&:class).count(Proc) > 1

          raise Howitzer::BadElementParamsError, 'Using more than 1 proc in arguments is forbidden'
        end

        def define_element(name, args, options)
          define_method("#{name}_element") do |*block_args, **block_options|
            kwdargs = options.transform_keys(&:to_sym).merge(block_options.transform_keys(&:to_sym))
            if kwdargs.present?
              capybara_context.find(*convert_arguments(args, block_args), **kwdargs)
            else
              capybara_context.find(*convert_arguments(args, block_args))
            end
          end
          private "#{name}_element"
        end

        def define_elements(name, args, options)
          define_method("#{name}_elements") do |*block_args, **block_options|
            kwdargs = options.transform_keys(&:to_sym).merge(block_options.transform_keys(&:to_sym))
            if kwdargs.present?
              capybara_context.all(*convert_arguments(args, block_args), **kwdargs)
            else
              capybara_context.all(*convert_arguments(args, block_args))
            end
          end
          private "#{name}_elements"
        end

        def define_wait_for_element(name, args, options)
          define_method("wait_for_#{name}_element") do |*block_args, **block_options|
            kwdargs = options.transform_keys(&:to_sym).merge(block_options.transform_keys(&:to_sym))
            if kwdargs.present?
              capybara_context.find(*convert_arguments(args, block_args), **kwdargs)
            else
              capybara_context.find(*convert_arguments(args, block_args))
            end
            return nil
          end
          private "wait_for_#{name}_element"
        end

        def define_within_element(name, args, options) # rubocop:disable Metrics/AbcSize
          define_method("within_#{name}_element") do |*block_args, **block_options, &block|
            kwdargs = options.transform_keys(&:to_sym).merge(block_options.transform_keys(&:to_sym))
            new_scope = if kwdargs.present?
                          capybara_context.find(*convert_arguments(args, block_args), **kwdargs)
                        else
                          capybara_context.find(*convert_arguments(args, block_args))
                        end
            begin
              capybara_scopes.push(new_scope)
              block.call
            ensure
              capybara_scopes.pop
            end
          end
        end

        def define_has_element(name, args, options)
          define_method("has_#{name}_element?") do |*block_args, **block_options|
            kwdargs = options.transform_keys(&:to_sym).merge(block_options.transform_keys(&:to_sym))
            if kwdargs.present?
              capybara_context.has_selector?(*convert_arguments(args, block_args), **kwdargs)
            else
              capybara_context.has_selector?(*convert_arguments(args, block_args))
            end
          end
        end

        def define_has_no_element(name, args, options)
          define_method("has_no_#{name}_element?") do |*block_args, **block_options|
            kwdargs = options.transform_keys(&:to_sym).merge(block_options.transform_keys(&:to_sym))
            if kwdargs.present?
              capybara_context.has_no_selector?(*convert_arguments(args, block_args), **kwdargs)
            else
              capybara_context.has_no_selector?(*convert_arguments(args, block_args))
            end
          end
        end
      end
    end
  end
end
