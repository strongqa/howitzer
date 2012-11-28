require "rspec/expectations"
require 'howitzer/utils/locator_store'

class WebPage

  BLANK_PAGE = 'about:blank'

  #TODO include Capybara DSL here
  include LocatorStore
  include RSpec::Matchers

  def self.open(url="#{settings.app_url}#{self::URL}")
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
      #TODO add not selenium drivers support
    #else
    #  page.execute_script("tinyMCE.get('#{name}').setContent('#{options[:with]}')")
    end
  end

  def wait_for_ajax(timeout=settings.timeout_small, message=nil)
    end_time = ::Time.now + timeout
    until ::Time.now > end_time
      return if page.evaluate_script('$.active') == 0
      sleep 0.25
      log.info "#{Time.now}"
    end
    log.error message || "Timed out waiting for ajax requests to complete"

  end

  def wait_for_url(expected_url, time_out=settings.timeout_small)
    wait_until(time_out) do
      operator = expected_url.is_a?(Regexp) ? :=~ : :==
      current_url.send(operator, expected_url).tap{|res| sleep 1 unless res}
    end
  rescue
    log.error "Current url: #{current_url}, expected:  #{expected_url}"
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