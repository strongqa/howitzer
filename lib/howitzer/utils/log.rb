require 'log4r'
require 'fileutils'

module Howitzer
  class Log
    include Singleton
    include Log4r

    [:debug, :info, :warn, :fatal].each do |method_name|
      define_method method_name do |text|
        @logger.send(method_name, text)
      end
    end

    # examples:
    #  log.error MyException, 'Some error text', caller
    #  log.error 'Some error text', caller
    #  log.error 'Some error text'
    #  log.error err_object
    def error(*args)
      object = if args.first.nil?
        $!
      else
        case args.size
          when 1
           args.first.is_a?(Exception) ? args.first : RuntimeError.new(args.first)
          when 2
           exception = RuntimeError.new(args.first)
           exception.set_backtrace(args.last)
           exception
          when 3
           exception = args.first.new(args[1])
           exception.set_backtrace(args.last)
           exception
          else nil
        end
      end
      err_backtrace = object.backtrace ? "\n\t#{object.backtrace.join("\n\t")}" : nil
      @logger.error("[#{object.class}] #{object.message}#{err_backtrace}")
      fail(object)
    end

    def print_feature_name(text)
      log_without_formatting{ info "*** Feature: #{text.upcase} ***" }
    end

    def settings_as_formatted_text
      log_without_formatting{ info settings.as_formatted_text }
    end

    def print_scenario_name(text)
      log_without_formatting{ info " => Scenario: #{text}" }
    end

    private

    def initialize
      @logger = Logger.new("ruby_log")
      @logger.add(console_log)
      @logger.add(error_log)
      @logger.add(txt_log)
      self.base_formatter = default_formatter
      Logger["ruby_log"].level = settings.debug_mode ? ALL : INFO
      Logger["ruby_log"].trace = true
    end

    def log_without_formatting
      self.base_formatter = blank_formatter
      yield
      self.base_formatter = default_formatter
    end

    def console_log
      StdoutOutputter.new(:console).tap{|o| o.only_at(INFO, DEBUG, WARN)}
    end

    def error_log
      StderrOutputter.new(:error, 'level' => ERROR)
    end

    def txt_log
      FileUtils.mkdir_p(settings.log_dir) unless File.exists?(settings.log_dir)
      filename = File.join(settings.log_dir, settings.txt_log)
      FileOutputter.new(:txt_log, :filename => filename, :trunc => true)
    end

    def blank_formatter
      PatternFormatter.new(:pattern => "%m")
    end

    def default_formatter
      if settings.hide_datetime_from_log
        params = {pattern: "[%l] %m"}
      else
        params = {pattern: "%d [%l] :: %m", date_pattern: "%Y/%m/%d %H:%M:%S"}
      end
      PatternFormatter.new(params)
    end

    def base_formatter=(formatter)
      @logger.outputters.each {|outputter| outputter.formatter = formatter}
    end
  end
end