require "rspec/expectations"
require 'howitzer/utils/locator_store'

class WebPage

  BLANK_PAGE = 'about:blank'
  IncorrectPageError = Class.new(StandardError)

  include LocatorStore
  include RSpec::Matchers
  include Capybara::DSL
  extend  Capybara::DSL


  def self.open(url="#{app_url}#{self::URL}")
    log.info "Open #{self.name} page by '#{url}' url"
    retryable(tries: 2, logger: log, trace: true, on: Exception) do |retries|
      log.info "Retry..." unless retries.zero?
      visit url
    end
    new
  end

  def self.given
    new
  end
  
  def tinymce_fill_in(name, options = {})
    if %w[selenium selenium_dev sauce].include? settings.driver
      page.driver.browser.switch_to.frame("#{name}_ifr")
      page.find(:css, '#tinymce').native.send_keys(options[:with])
      page.driver.browser.switch_to.default_content
    else
      page.execute_script("tinyMCE.get('#{name}').setContent('#{options[:with]}')")
    end
  end
  
   def click_alert_box(flag)
    if %w[selenium selenium_dev sauce].include? settings.driver
      if flag
        page.driver.browser.switch_to.alert.accept
      else
        page.driver.browser.switch_to.alert.dismiss
      end
    else
      if flag
        page.evaluate_script('window.confirm = function() { return true; }')
      else
        page.evaluate_script('window.confirm = function() { return false; }')
      end
    end
  end
  
  def js_click(css_locator)
    page.execute_script("$('#{css_locator}').trigger('click')")
    sleep settings.timeout_tiny
  end

  # @deprecated
  # With Capybara 2.x it is extra
  def wait_for_ajax(timeout=settings.timeout_small, message=nil)
    end_time = ::Time.now + timeout
    until ::Time.now > end_time
      return true if page.evaluate_script('$.active') == 0
      sleep 0.25
    end
    log.error message || "Timed out waiting for ajax requests to complete"
  end

  def wait_for_url(expected_url, timeout=settings.timeout_small)
    end_time = ::Time.now + timeout
    until ::Time.now > end_time
      operator = expected_url.is_a?(Regexp) ? :=~ : :==
      return true if current_url.send(operator, expected_url).tap{|res| sleep 1 unless res}
    end
    log.error IncorrectPageError, "Current url: #{current_url}, expected:  #{expected_url}"
  end

  def reload
    log.info "Reload '#{current_url}'"
    visit current_url
  end

  def self.current_url
    page.current_url
  end

  def self.text
    page.find('body').text
  end

  private
  def initialize
    wait_for_url(self.class::URL_PATTERN)
  end
end
