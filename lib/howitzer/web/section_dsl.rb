module Howitzer
  module Web
    # This module combines section dsl methods
    module SectionDsl
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end

      # This module holds section dsl class methods
      module ClassMethods
        # This class is for private usage only
        class SectionScope
          attr_accessor :section_class

          def initialize(name, *args, &block)
            @args = args
            self.section_class = block ? Class.new(AnonymousSection) : "#{name}_section".classify.constantize
            instance_eval(&block) if block_given?
          end

          def element(*args)
            section_class.element(*args)
          end

          def finder_args
            @finder_args ||= begin
              return @args if @args.present?
              section_class.default_finder_args || raise(ArgumentError, 'Missing finder arguments')
            end
          end
        end

        protected

        # TODO: describe me
        #
        def section(name, *args, &block)
          scope = SectionScope.new(name, *args, &block)
          define_dynamic_methods(scope.section_class, name, scope.finder_args)
        end

        private

        def define_dynamic_methods(klass, name, args)
          capybara_context = Capybara.current_session
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
