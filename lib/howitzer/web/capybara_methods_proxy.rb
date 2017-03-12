require 'capybara'

# Remove this monkey patch after fixing the bugs in selenium-webdriver / capybara
#:nocov:
class Capybara::Selenium::Driver # rubocop:disable Style/ClassAndModuleChildren
  #
  # https://github.com/teamcapybara/capybara/issues/1845
  def title
    return browser.title unless within_frame?
    find_xpath('/html/head/title').map { |n| n[:text] }.first
  end

  # Known issue, works differently for phantomjs and real browsers
  # https://github.com/seleniumhq/selenium/issues/1727
  def current_url
    return browser.current_url unless within_frame?
    execute_script('return document.location.href')
  end

  private

  def within_frame?
    !(@frame_handles.empty? || @frame_handles[browser.window_handle].empty?)
  end
end
#:nocov:

module Howitzer
  module Web
    # This module proxies required original capybara methods to recipient
    module CapybaraMethodsProxy
      PROXIED_CAPYBARA_METHODS = Capybara::Session::SESSION_METHODS + #:nodoc:
                                 Capybara::Session::MODAL_METHODS +
                                 [:driver, :text]

      # Capybara form dsl methods are not compatible with page object pattern and Howitzer gem.
      # Instead of including Capybara::DSL module, we proxy most interesting Capybara methods and
      # prevent using extra methods which can potentially broke main principles and framework concept
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

      private

      def capybara_scopes
        @_scopes ||= [Capybara.current_session]
      end
    end
  end
end
