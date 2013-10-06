require "rspec/expectations"
require "howitzer/utils/locator_store"
require "howitzer/utils/page_validator"
require "singleton"

class WebPage

  BLANK_PAGE = 'about:blank'
  IncorrectPageError = Class.new(StandardError)

  include LocatorStore
  include Howitzer::Utils::PageValidator
  include RSpec::Matchers
  include Capybara::DSL
  extend  Capybara::DSL
  include Singleton

  def self.inherited(subclass)
    subclass.class_eval { include Singleton }
  end

  ##
  #
  # Opens web-site by given url
  #
  # *Parameters:*
  # * +url+ - Url string that will be opened
  #
  # *Returns:*
  # * +WebPage+ - New instance of current class
  #

  def self.open(url="#{app_url}#{self::URL}")
    log.info "Open #{self.name} page by '#{url}' url"
    retryable(tries: 2, logger: log, trace: true, on: Exception) do |retries|
      log.info "Retry..." unless retries.zero?
      visit url
    end
    given
  end

  ##
  #
  # Returns singleton instance of current web page
  #
  # *Returns:*
  # * +WebPage+ - Singleton instance
  #

  def self.given
    self.instance.tap{ |page| page.check_correct_page_loaded }
  end

  ##
  #
  # Fills in field that using Tinymce API
  #
  # *Parameters:*
  # * +name+ - Frame name that contains Tinymce field
  # * +Hash+ - Not required options
  #

  def tinymce_fill_in(name, options = {})
    if %w[selenium selenium_dev sauce].include? settings.driver
      page.driver.browser.switch_to.frame("#{name}_ifr")
      page.find(:css, '#tinymce').native.send_keys(options[:with])
      page.driver.browser.switch_to.default_content
    else
      page.execute_script("tinyMCE.get('#{name}').setContent('#{options[:with]}')")
    end
  end

  ##
  #
  # Accepts or declines JS alert box by given flag
  #
  # *Parameters:*
  # * +flag+ [TrueClass,FalseClass] - Determines accept or decline alert box
  #

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

  ##
  #
  # Clicks on button or link using JS event call
  #
  # *Parameters:*
  # * +css_locator+ - Css locator of link or button
  #

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

  ##
  #
  # Waits until web page is loaded
  #
  # *Parameters:*
  # * +expected_url+ - Url that will be waiting for
  # * +time_out+ - Seconds that will be waiting for web-site to be loaded until raise error
  #

  def wait_for_url(expected_url, timeout=settings.timeout_small)
    end_time = ::Time.now + timeout
    until ::Time.now > end_time
      operator = expected_url.is_a?(Regexp) ? :=~ : :==
      return true if current_url.send(operator, expected_url).tap{|res| sleep 1 unless res}
    end
    log.error IncorrectPageError, "Current url: #{current_url}, expected:  #{expected_url}"
  end

  ##
  #
  # Waits until web is loaded with expected title
  #
  # *Parameters:*
  # * +expected_title+ - Page title that will be waited for
  # * +time_out+ - Seconds that will be waiting for web-site to be loaded until raise error
  #

  def wait_for_title(expected_title, timeout=settings.timeout_small)
    end_time = ::Time.now + timeout
    until ::Time.now > end_time
      operator = expected_title.is_a?(Regexp) ? :=~ : :==
      return true if title.send(operator, expected_title).tap{|res| sleep 1 unless res}
    end
    log.error IncorrectPageError, "Current title: #{title}, expected:  #{expected_title}"
  end

  ##
  #
  # Reloads current page
  #

  def reload
    log.info "Reload '#{current_url}'"
    visit current_url
  end

  ##
  #
  # Returns current url
  #
  # *Returns:*
  # * +string+ - Current url
  #

  def self.current_url
    page.current_url
  end

  ##
  #
  # Returns Page title
  #
  # *Returns:*
  # * +string+ - Page title
  #

  def title
    page.title
  end

  ##
  #
  # Returns body text of html page
  #
  # *Returns:*
  # * +string+ - Body text
  #

  def self.text
    page.find('body').text
  end
end
