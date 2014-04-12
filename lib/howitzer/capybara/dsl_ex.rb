require 'capybara'
module Howitzer
  module Capybara
    module DslEx
      include ::Capybara::DSL

      # It flattens arguments of all DSL methods to support locator store DSL
      ::Capybara::Session::DSL_METHODS.each do |method|
        define_method method do |*args, &block|
          super(*args.map{|el| el.respond_to?(:flatten) ? el.flatten : el}.flatten, &block)
        end
      end
    end
  end
end