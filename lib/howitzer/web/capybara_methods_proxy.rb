require 'capybara'

module Howitzer
  # This module proxies required original capybara methods to recipient
  module CapybaraMethodsProxy
    PROXIED_CAPYBARA_METHODS = Capybara::Session::SESSION_METHODS +
                               Capybara::Session::MODAL_METHODS +
                               [:driver, :text]

    PROXIED_CAPYBARA_METHODS.each do |method|
      define_method(method) { |*args, &block| Capybara.current_session.send(method, *args, &block) }
    end

    # Accepts or declines JS alert box by given flag
    # @param flag [Boolean] Determines accept or decline alert box

    def click_alert_box(flag)
      if %w(selenium sauce).include? Howitzer.driver
        alert = driver.browser.switch_to.alert
        flag ? alert.accept : alert.dismiss
      else
        evaluate_script("window.confirm = function() { return #{flag}; }")
      end
    end
  end
end
