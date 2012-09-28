require 'log4r'
require 'fileutils'

module AppLogger
  include Log4r

  @logger = Logger.new("ruby_log")

  #STDOUT
  console_log = StdoutOutputter.new(:console)
  console_log.only_at(INFO, DEBUG, WARN)
  @logger.add(console_log)

  #STDERR
  error_log = StderrOutputter.new(:error, 'level' => ERROR)
  @logger.add(error_log)

  #Txt outputter
  FileUtils.mkdir_p(settings.log_dir) unless File.exists?(settings.log_dir)
  filename = File.join(settings.log_dir, settings.txt_log)

  txt_log = FileOutputter.new(:txt_log, :filename => filename, :trunc => true)
  @logger.add(txt_log)


  def self.log
    @logger
  end

  def self.blank_formatter
    PatternFormatter.new(:pattern => "%m")
  end

  def self.default_formatter

    if settings.hide_datetime_from_log
      params = {pattern: "[%l] %m"}
    else
      params = {pattern: "%d [%l] :: %m", date_pattern: "%Y/%m/%d %H:%M:%S"}
    end
    PatternFormatter.new(params)
  end

  def self.base_formatter=(formatter)
    @logger.outputters.each {|outputter| outputter.formatter = formatter}
  end

  AppLogger.base_formatter = AppLogger.default_formatter
  Logger["ruby_log"].level = settings.debug_mode ? ALL : INFO
  Logger["ruby_log"].trace = true
end

def log
  AppLogger.log
end

AppLogger.base_formatter = AppLogger.blank_formatter
#log.info settings.pretty_formatted_properties
AppLogger.base_formatter = AppLogger.default_formatter

def log.print_feature_name(text)
  AppLogger.base_formatter = AppLogger.blank_formatter
  log.info "*** Feature: #{text.upcase} ***"
  AppLogger.base_formatter = AppLogger.default_formatter
end

def log.settings_as_formatted_text
  AppLogger.base_formatter = AppLogger.blank_formatter
  log.info settings.as_formatted_text
  AppLogger.base_formatter = AppLogger.default_formatter
end

def log.print_scenario_name(text)
  AppLogger.base_formatter = AppLogger.blank_formatter
  log.info " => Scenario: #{text}"
  AppLogger.base_formatter = AppLogger.default_formatter
end

class << log
  eval "alias :n_error :error"
end

# examples:
#  log.error MyException, 'Some error text', caller
#  log.error 'Some error text', caller
#  log.error 'Some error text'
#  log.error err_object
def log.error(*args)
  if args.first.nil?
    object = $!
  else
    object = case args.size
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
             end
  end
  err_backtrace = "\n\t#{object.backtrace.join("\n\t")}" unless object.backtrace.nil?
  self.n_error("[#{object.class}] #{object.message}#{err_backtrace}")
  fail(object)
end
