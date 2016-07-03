module Howitzer
  module Web
    # This module combines section dsl methods
    module SectionDsl
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end

      # This module holds section dsl class methods
      module ClassMethods
        protected

        # TODO: describe me
        #
        def section(name, *args)
          klass = section_class(name, with_block: block_given?)
          define_dynamic_methods(klass, name, finder_args(klass, args))
        end

        private

        def section_class(name, with_block: false)
          if with_block
            AnonymousSection
          else
            "#{name}_section".classify.constantize
          end
        end

        def finder_args(klass, args)
          @finder_args ||= begin
            return args if args.present?
            klass.default_finder_args || raise(ArgumentError, 'Missing finder arguments')
          end
        end

        def context
          Capybara.current_session
        end

        def define_dynamic_methods(klass, name, args)
          capybara_context = context
          define_method("#{name}_section") do
            klass.new(self, capybara_context.find(*args))
          end

          define_method("#{name}_sections") do
            capybara_context.all(*args).map { |el| klass.new(self, el) }
          end

          define_method("has_#{name}_section?") do
            capybara_context.has_selector?(*args)
          end

          define_method("has_no_#{name}_section?") do
            capybara_context.has_no_selector?(*args)
          end

          private "#{name}_section", "#{name}_sections"
        end
      end
    end
  end
end
