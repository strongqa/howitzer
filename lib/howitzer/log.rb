require 'log4r'
require 'fileutils'
require 'active_support/core_ext/module'

module Howitzer
  # This class represents logger
  class Log
    include Singleton
    include Log4r

    class << self
      # Delegates all public instance methods to the class
      delegate :debug, :info, :warn, :fatal, :error, :print_feature_name,
               :settings_as_formatted_text, :print_scenario_name, to: :instance
    end

    # Outputs debug message if Howitzer.debug_mode == true
    # @param msg [String] a message

    def debug(msg)
      @logger.debug(msg)
    end

    # Outputs info message
    # @param msg [String] a message

    def info(msg)
      @logger.info(msg)
    end

    # Outputs warn message
    # @param msg [String] a message

    def warn(msg)
      @logger.warn(msg)
    end

    # Outputs error message
    # @param msg [String] a message

    def error(msg)
      @logger.error(msg)
    end

    # Outputs fatal message
    # @param msg [String] a message

    def fatal(msg)
      @logger.fatal(msg)
    end

    # Outputs a feature name into the log with INFO severity
    # @param text [String] a feature name

    def print_feature_name(text)
      log_without_formatting { info "*** Feature: #{text.upcase} ***" }
    end

    # Outputs formatted howitzer settings

    def settings_as_formatted_text
      log_without_formatting { info ::SexySettings::Base.instance.as_formatted_text }
    end

    # Outputs a scenario name into log with INFO severity
    # @param text [String] a scenario name

    def print_scenario_name(text)
      log_without_formatting { info " => Scenario: #{text}" }
    end

    private

    def initialize
      @logger = Logger.new('ruby_log')
      @logger.add(console_log)
      @logger.add(error_log)
      self.base_formatter = default_formatter
      Logger['ruby_log'].level = Howitzer.debug_mode ? ALL : INFO
      Logger['ruby_log'].trace = true
    end

    # :nocov:
    def log_without_formatting
      self.base_formatter = blank_formatter
      yield
      self.base_formatter = default_formatter
    end
    # :nocov:

    def console_log
      StdoutOutputter.new(:console).tap { |o| o.only_at(INFO, DEBUG, WARN) }
    end

    def error_log
      StderrOutputter.new(:error, 'level' => ERROR)
    end

    # :nocov:
    def blank_formatter
      PatternFormatter.new(pattern: '%m')
    end
    # :nocov:

    # :nocov:
    def default_formatter
      params = if Howitzer.hide_datetime_from_log
                 { pattern: '[%l] %m' }
               else
                 { pattern: '%d [%l] :: %m', date_pattern: '%Y/%m/%d %H:%M:%S' }
               end
      PatternFormatter.new(params)
    end
    # :nocov:

    def base_formatter=(formatter)
      @logger.outputters.each { |outputter| outputter.formatter = formatter }
    end
  end
end
