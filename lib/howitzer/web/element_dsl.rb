module Howitzer
  module Web
    # This module combines element dsl methods
    module ElementDsl
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end

      # Returns capybara context. For example, capybara session, parent element, etc.
      # @abstract should be defined in parent context
      def capybara_context
        raise NotImplementedError, "Please define 'capybara_context' method for class holder"
      end

      private

      def convert_arguments(args, params)
        args.map do |arg|
          arg.is_a?(Proc) ? arg.call(*params) : arg
        end
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
        #   <b>has_<em>element_name</em>_element?</b> - equals capybara #has_selector(...) method
        #
        #   <b>has_no_<em>element_name</em>_element?</b> - equals capybara #has_no_selector(...) method
        # @param name [Symbol, String] unique element name
        # @param args [Array] original Capybara arguments. For details, see `Capybara::Node::Finders#all.
        # @example Using in page class
        #   class HomePage < Howitzer::Web::Page
        #     element :new_button, :xpath, ".//*[@name='New']"
        #
        #     def press_new_button
        #       new_button_element.click
        #     end
        #   end
        #
        #   HomePage.on { is_expected.to have_new_button_element }
        #   HomePage.on { is_expected.to have_no_new_button_element }
        # @example Using in section class
        #   class MenuSection < Howitzer::Web::Section
        #     me '.main-menu'
        #     element :menu_item, '.item'
        #
        #     def menu_items
        #       menu_item_elements.map(&:text)
        #     end
        #   end
        # @!visibility public

        def element(name, *args)
          validate_arguments!(args)
          define_element(name, args)
          define_elements(name, args)
          define_has_element(name, args)
          define_has_no_element(name, args)
        end

        private

        def validate_arguments!(args)
          return unless args.map(&:class).count(Proc) > 1

          raise BadElementParamsError, 'Using more than 1 proc in arguments is forbidden'
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
