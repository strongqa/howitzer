module Howitzer
  # This module combines element dsl methods
  module WebPageElement
    def self.included(base) #:nodoc:
      base.extend(ClassMethods)
    end

    # This module holds page validation class methods
    module ClassMethods
      def element(name, *args)
        define_method("#{name}_element") { find(*args) }
        define_method("#{name}_elements") { all(*args) }
        define_method("has_#{name}_element?") do
          has_selector?(*args)
        end
        define_method("has_no_#{name}_element?") do
          has_no_selector?(*args)
        end
      end
    end
  end
end
