require 'log4r'
require 'fileutils'

module Howitzer
  module Utils
    # This class represents logger
    class Log
      include Singleton
      include Log4r

      [:debug, :info, :warn, :fatal].each do |method_name|
        define_method method_name do |text|
          @logger.send(method_name, text)
        end
      end

      ##
      #
      # Prints log entry about error with ERROR severity
      # *Examples:*
      #  log.error MyException, 'Some error text', caller
      #  log.error 'Some error text', caller
      #  log.error MyException, 'Some caller text'
      #  log.error 'Some error text'
      #  log.error err_object
      #
      # *Parameters:*
      # * +args+ - see example
      #

      def error(*args)
        object = error_object(*args)
        err_backtrace = object.backtrace ? "\n\t#{object.backtrace.join("\n\t")}" : nil
        @logger.error("[#{object.class}] #{object.message}#{err_backtrace}")
        fail(object)
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
        log_without_formatting { info settings.as_formatted_text }
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
        Logger['ruby_log'].level = settings.debug_mode ? ALL : INFO
        Logger['ruby_log'].trace = true
      end

      def log_without_formatting
        self.base_formatter = blank_formatter
        yield
        self.base_formatter = default_formatter
      end

      def console_log
        StdoutOutputter.new(:console).tap { |o| o.only_at(INFO, DEBUG, WARN) }
      end

      def error_log
        StderrOutputter.new(:error, 'level' => ERROR)
      end

      def blank_formatter
        PatternFormatter.new(pattern: '%m')
      end

      def default_formatter
        params = if settings.hide_datetime_from_log
                   { pattern: '[%l] %m' }
                 else
                   { pattern: '%d [%l] :: %m', date_pattern: '%Y/%m/%d %H:%M:%S' }
                 end
        PatternFormatter.new(params)
      end

      def base_formatter=(formatter)
        @logger.outputters.each { |outputter| outputter.formatter = formatter }
      end

      def error_object(*args)
        case args.size
          when 0
            $ERROR_INFO
          when 1
            args.first.is_a?(Exception) ? args.first : RuntimeError.new(args.first)
          when 2
            error_object_for_two_args(args.first, args.last)
          when 3
            exception = args.first.new(args[1])
            exception.set_backtrace(args.last)
            exception
          #:nocov:
          else nil
          #:nocov:
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
end
