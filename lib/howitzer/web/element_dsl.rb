module Howitzer
  module Web
    # This module combines element dsl methods
    module ElementDsl
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
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

        # TODO: describe me
        #
        def element(name, *args)
          validate_arguments!(args)
          define_element_methods(name, args)
        end

        private

        def validate_arguments!(args)
          return unless args.map(&:class).count(Proc) > 1

          raise BadElementParamsError, 'Using more than 1 proc in arguments is forbidden'
        end

        def context
          Capybara.current_session
        end

        def define_element_methods(name, args)
          capybara_context = context
          define_method("#{name}_element") do |*block_args|
            capybara_context.find(*convert_arguments(args, block_args))
          end

          define_method("#{name}_elements") do |*block_args|
            capybara_context.all(*convert_arguments(args, block_args))
          end

          define_method("has_#{name}_element?") do |*block_args|
            capybara_context.has_selector?(*convert_arguments(args, block_args))
          end

          define_method("has_no_#{name}_element?") do |*block_args|
            capybara_context.has_no_selector?(*convert_arguments(args, block_args))
          end

          private "#{name}_element", "#{name}_elements"
        end
      end
    end
  end
end
