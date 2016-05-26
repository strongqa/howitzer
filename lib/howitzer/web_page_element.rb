module Howitzer
  # This module combines element dsl methods
  module WebPageElement
    def self.included(base) #:nodoc:
      base.extend(ClassMethods)
    end

    private

    def convert_arguments(args, params)
      args.map do |arg|
        arg.is_a?(Proc) ? arg.call(*params) : arg
      end
    end

    # This module holds page validation class methods
    module ClassMethods
      private

      # TODO: describe me
      #
      def element(name, *args)
        validate_arguments!(args)

        define_method("#{name}_element") do |*block_args|
          find(*convert_arguments(args, block_args))
        end

        define_method("#{name}_elements") do |*block_args|
          all(*convert_arguments(args, block_args))
        end

        define_method("has_#{name}_element?") do |*block_args|
          has_selector?(*convert_arguments(args, block_args))
        end

        define_method("has_no_#{name}_element?") do |*block_args|
          has_no_selector?(*convert_arguments(args, block_args))
        end

        private "#{name}_element", "#{name}_elements"
      end

      def validate_arguments!(args)
        return unless args.map(&:class).count(Proc) > 1

        raise BadElementParamsError, 'Using more than 1 proc in arguments is forbidden'
      end
    end
  end
end
