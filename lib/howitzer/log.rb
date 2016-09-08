require 'log4r'
require 'fileutils'

module Howitzer
  # This class represents logger
  class Log
    include Singleton
    include Log4r

    # @todo implement documentation here!
    [:debug, :info, :warn, :fatal].each do |method_name|
      define_method method_name do |text|
        @logger.send(method_name, text)
      end
      class << self
        [
          :debug,
          :info,
          :warn,
          :fatal,
          :error,
          :print_feature_name,
          :settings_as_formatted_text,
          :print_scenario_name
        ].each do |method_name|
          define_method method_name do |*args|
            instance.send(method_name, *args)
          end
        end
      end
    end

    ##
    #
    # Prints log entry about error with ERROR severity
    # *Examples:*
    #  Howitzer::Log.error MyException, 'Some error text', caller
    #  Howitzer::Log.error 'Some error text', caller
    #  Howitzer::Log.error MyException, 'Some caller text'
    #  Howitzer::Log.error 'Some error text'
    #  Howitzer::Log.error err_object
    #
    # *Parameters:*
    # * +args+ - see example
    #

    def error(*args)
      object = error_object(*args)
      err_backtrace = object.backtrace ? "\n\t#{object.backtrace.join("\n\t")}" : nil
      @logger.error("[#{object.class}] #{object.message}#{err_backtrace}")
      raise(object)
    end

    ##
    #
    # Prints feature name into log with INFO severity
    #
    # *Parameters:*
    # * +text+ - Feature name
    #

    def print_feature_name(text)
      log_without_formatting { info "*** Feature: #{text.upcase} ***" }
    end

    ##
    #
    # Returns formatted howitzer settings
    #

    def settings_as_formatted_text
      log_without_formatting { info ::SexySettings::Base.instance.as_formatted_text }
    end

    ##
    #
    # Prints scenario name into log with INFO severity
    #
    # *Parameters:*
    # * +text+ - Scenario name
    #
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

    #:nocov:
    def log_without_formatting
      self.base_formatter = blank_formatter
      yield
      self.base_formatter = default_formatter
    end
    #:nocov:

    def console_log
      StdoutOutputter.new(:console).tap { |o| o.only_at(INFO, DEBUG, WARN) }
    end

    def error_log
      StderrOutputter.new(:error, 'level' => ERROR)
    end

    #:nocov:
    def blank_formatter
      PatternFormatter.new(pattern: '%m')
    end
    #:nocov:

    #:nocov:
    def default_formatter
      params = if Howitzer.hide_datetime_from_log
                 { pattern: '[%l] %m' }
               else
                 { pattern: '%d [%l] :: %m', date_pattern: '%Y/%m/%d %H:%M:%S' }
               end
      PatternFormatter.new(params)
    end
    #:nocov:

    def base_formatter=(formatter)
      @logger.outputters.each { |outputter| outputter.formatter = formatter }
    end

    def error_object(value, *args)
      case args.size
      when 0
        value.is_a?(Exception) ? value : RuntimeError.new(value)
      when 1
        error_object_for_two_args(value, args.last)
      else
        exception = value.new(args.first)
        exception.set_backtrace(args[1]) if args[1]
        exception
      end
    end

    def error_object_for_two_args(arg1, arg2)
      if arg1.is_a?(Class) && arg1 < Exception
        arg1.new(arg2)
      else
        exception = RuntimeError.new(arg1)
        exception.set_backtrace(arg2)
        exception
      end
    end
  end
end
