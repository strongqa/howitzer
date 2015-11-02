require 'singleton'
require 'rspec/expectations'
require 'howitzer/utils/locator_store'
require 'howitzer/utils/page_validator'
require 'howitzer/capybara/dsl_ex'
require 'howitzer/exceptions'

# This class describes methods for web page. Parent class for all pages
class WebPage
  UnknownPage = Class.new

  include LocatorStore
  include Howitzer::Utils::PageValidator
  include RSpec::Matchers
  include Howitzer::Capybara::DslEx
  extend Howitzer::Capybara::DslEx
  include Singleton

  def self.inherited(subclass)
    subclass.class_eval { include Singleton }
    Howitzer::Utils::PageValidator.pages << subclass
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

  def self.open(url = "#{app_url unless self == BlankPage}#{self::URL}")
    log.info "Open #{name} page by '#{url}' url"
    retryable(tries: 2, logger: log, trace: true, on: Exception) do |retries|
      log.info 'Retry...' unless retries.zero?
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
    wait_for_opened
    instance
  end

  ##
  #
  # Returns current url
  #
  # *Returns:*
  # * +string+ - Current url
  #

  def self.url
    current_url
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

  ##
  #
  # Tries to identify current page name or raise error if ambiguous page matching
  #
  # *Returns:*
  # * +string+ - page name
  #

  def self.current_page
    page_list = matched_pages
    if page_list.count.zero?
      UnknownPage
    elsif page_list.count > 1
      log.error Howitzer::AmbiguousPageMatchingError,
                "Current page matches more that one page class (#{page_list.join(', ')}).\n" \
                "\tCurrent url: #{current_url}\n\tCurrent title: #{title}"
    elsif page_list.count == 1
      page_list.first
    end
  end

  ##
  #
  # Waits until web page is not opened, or raise error after timeout
  #
  # *Parameters:*
  # * +time_out+ - Seconds that will be waiting for web page to be loaded
  #

  def self.wait_for_opened(timeout = settings.timeout_small)
    end_time = ::Time.now + timeout
    self.opened? ? return : sleep(0.5) until ::Time.now > end_time
    log.error Howitzer::IncorrectPageError, "Current page: #{current_page}, expected: #{self}.\n" \
              "\tCurrent url: #{current_url}\n\tCurrent title: #{title}"
  end

  def initialize
    check_validations_are_defined!
    page.driver.browser.manage.window.maximize if settings.maximized_window
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
    if %w(selenium selenium_dev sauce).include?(settings.driver)
      browser_tinymce_fill_in(name, options)
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
    if %w(selenium selenium_dev sauce).include? settings.driver
      alert = page.driver.browser.switch_to.alert
      flag ? alert.accept : alert.dismiss
    else
      page.evaluate_script("window.confirm = function() { return #{flag}; }")
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

  def reload
    log.info "Reload '#{current_url}'"
    visit current_url
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

  private

  def browser_tinymce_fill_in(name, options = {})
    page.driver.browser.switch_to.frame("#{name}_ifr")
    page.find(:css, '#tinymce').native.send_keys(options[:with])
  ensure
    page.driver.browser.switch_to.default_content
  end
end
