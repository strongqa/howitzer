module CapybaraPatched
  class Capybara::Selenium::PatchedDriver < Capybara::Selenium::Driver
    RETRY_ON = [
        ::Selenium::WebDriver::Error::UnhandledError,
        ::Selenium::WebDriver::Error::UnknownError,
        ::Selenium::WebDriver::Error::InvalidSelectorError
    ]

    # workaround for transferring correct arguments via call stack
    Capybara::Session.instance_eval do
      self::NODE_METHODS.each do |method|
        class_eval <<-RUBY
        def #{method}(*args, &block)
          retryable(tries:3, logger: log, trace: true, on: RETRY_ON) do
            @touched = true
            current_scope.send(:#{method}, *args.flatten, &block)
          end
        end
        RUBY
      end
    end
  end
end
