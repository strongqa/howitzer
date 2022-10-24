module Howitzer
  module Utils
    # This module mixes in private utils methods for section and element dsl
    module ArgumentConvertable
      private

      def convert_arguments(args, options, block_args, block_options)
        conv_args = args.map { |el| el.is_a?(Proc) ? proc_to_selector(el, block_args, block_options) : el }
        args_options = pop_options_from_array(conv_args)
        block_args_options = pop_options_from_array(block_args)
        conv_options = [args_options, options, block_args_options, block_options].map do |el|
          el.transform_keys(&:to_sym)
        end.reduce(&:merge).except(:lambda_args)
        [conv_args, conv_options]
      end

      def proc_to_selector(proc, block_args, block_options)
        lambda_args = extract_lambda_args(block_args, block_options)
        if lambda_args
          if lambda_args[:keyword_args].present?
            proc.call(*lambda_args[:args], **lambda_args[:keyword_args])
          else
            proc.call(*lambda_args[:args])
          end
        else
          puts "WARNING! Passing lambda arguments with element options is deprecated.\n" \
               "Please use 'lambda_args' method, for example: foo_element(lambda_args(title: 'Example'), wait: 10)"
          proc.call(*block_args.shift(proc.arity))
        end
      end

      def extract_lambda_args(block_args, block_options)
        (block_args.first.is_a?(Hash) && block_args.first[:lambda_args]) || block_options[:lambda_args]
      end

      def pop_options_from_array(value)
        if value.last.is_a?(Hash) && !value.last.key?(:lambda_args)
          value.pop
        else
          {}
        end
      end

      def lambda_args(*args, **keyword_args)
        {
          lambda_args: {
            args: args,
            keyword_args: keyword_args
          }
        }
      end
    end
  end
end
