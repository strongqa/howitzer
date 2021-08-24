require 'howitzer/web/capybara_context_holder'
module Howitzer
  module Web
    # This module combines element dsl methods
    module ElementDsl
      include CapybaraContextHolder

      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end

      private

      def convert_arguments(args, params)
        args, params, options = merge_element_options(args, params)
        args = args.map do |el|
          next(el) unless el.is_a?(Proc)

          el.call(*params.shift(el.arity))
        end
        args << options unless options.blank?
        args
      end

      def merge_element_options(args, params)
        new_args, args_hash = extract_element_options(args)
        new_params, params_hash = extract_element_options(params)
        [new_args, new_params, args_hash.merge(params_hash)]
      end

      def extract_element_options(args)
        new_args = args.deep_dup
        args_hash = {}
        args_hash = new_args.pop if new_args.last.is_a?(Hash)
        [new_args, args_hash]
      end

      # This module holds element dsl methods methods
      module ClassMethods
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

        def element(name, *args)
          validate_arguments!(args)
          define_element(name, args)
          define_elements(name, args)
          define_wait_for_element(name, args)
          define_within_element(name, args)
          define_has_element(name, args)
          define_has_no_element(name, args)
        end

        private

        def validate_arguments!(args)
          return unless args.map(&:class).count(Proc) > 1

          raise Howitzer::BadElementParamsError, 'Using more than 1 proc in arguments is forbidden'
        end

        def define_element(name, args)
          define_method("#{name}_element") do |*block_args|
            capybara_context.find(*convert_arguments(args, block_args))
          end
          private "#{name}_element"
        end

        def define_elements(name, args)
          define_method("#{name}_elements") do |*block_args|
            capybara_context.all(*convert_arguments(args, block_args))
          end
          private "#{name}_elements"
        end

        def define_wait_for_element(name, args)
          define_method("wait_for_#{name}_element") do |*block_args|
            capybara_context.find(*convert_arguments(args, block_args))
            return nil
          end
          private "wait_for_#{name}_element"
        end

        def define_within_element(name, args)
          define_method("within_#{name}_element") do |*block_args, &block|
            new_scope = capybara_context.find(*convert_arguments(args, block_args))
            begin
              capybara_scopes.push(new_scope)
              block.call
            ensure
              capybara_scopes.pop
            end
          end
        end

        def define_has_element(name, args)
          define_method("has_#{name}_element?") do |*block_args|
            capybara_context.has_selector?(*convert_arguments(args, block_args))
          end
        end

        def define_has_no_element(name, args)
          define_method("has_no_#{name}_element?") do |*block_args|
            capybara_context.has_no_selector?(*convert_arguments(args, block_args))
          end
        end
      end
    end
  end
end
