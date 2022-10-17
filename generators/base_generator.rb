require 'colorized_string'
require 'fileutils'
require 'erb'
require 'ostruct'
require 'active_support/core_ext/hash'

module Howitzer
  # This module combines all methods related with information printing to stdout
  module Outputable
    def self.included(base)
      class << base
        attr_accessor :logger
      end
    end

    def initialize
      print_banner
    end

    protected

    def banner; end

    def logger
      BaseGenerator.logger || $stdout
    end

    def destination
      BaseGenerator.destination || Dir.pwd
    end

    def print_banner
      logger.puts ColorizedString.new(banner.chomp).light_cyan unless banner.empty?
    end

    def print_info(data)
      logger.print "      #{data}"
    end

    def puts_info(data)
      logger.puts "      #{data}"
    end

    def puts_error(data)
      logger.puts ColorizedString.new("      ERROR: #{data}").red
    end
  end

  # This module combines methods for copying files and templates
  module Copyable
    def self.included(base)
      class << base
        attr_accessor :destination
      end
    end

    def initialize
      super

      manifest.each do |type, list|
        case type
          when :files
            copy_files(list)
          when :templates
            copy_templates(list)
          else nil
        end
      end
    end

    def manifest
      []
    end

    def template_context
      data = options
      data = options.merge(project_name: project_name) unless project_name.nil?
      OpenStruct.new(data) # rubocop:disable Style/OpenStructUse
    end

    protected

    def copy_files(list)
      list.each do |data|
        source_file = source_path(data[:source])
        File.exist?(source_file) ? copy_with_path(data) : puts_error("File '#{source_file}' was not found.")
      end
    end

    def copy_templates(list)
      list.each do |data|
        destination_path = dest_path(data[:destination])
        source_path = source_path(data[:source])
        if File.exist?(destination_path)
          copy_templates_file_exist(data, destination_path, source_path)
        else
          write_template(destination_path, source_path)
          puts_info "#{ColorizedString.new('Added').light_green} template '#{data[:source]}' with " \
                    "params '#{template_context.to_h}' to destination '#{data[:destination]}'"
        end
      end
    end

    def source_path(file_name)
      base_name = self.class.name.sub('Generator', '').sub('Howitzer::', '').downcase
      File.expand_path(file_name, File.join(__dir__, base_name, 'templates'))
    end

    def dest_path(path)
      File.expand_path(File.join(destination, path))
    end

    def copy_with_path(data)
      src, dst = get_source_and_destination(data)
      FileUtils.mkdir_p(File.dirname(dst))
      if File.exist?(dst)
        copy_with_path_file_exist(data, src, dst)
      else
        FileUtils.cp(src, dst)
        puts_info("#{ColorizedString.new('Added').light_green} '#{data[:destination]}' file")
      end
    rescue => e
      puts_error("Impossible to create '#{data[:destination]}' file. Reason: #{e.message}")
    end

    def write_template(dest_path, source_path)
      File.write(
        dest_path,
        ERB.new(File.read(source_path), trim_mode: '-').result(template_context.instance_eval { binding })
      )
    end

    private

    def get_source_and_destination(data)
      [source_path(data[:source]), dest_path(data[:destination])]
    end

    def conflict_file_msg(data)
      ColorizedString.new("Conflict with '#{data[:destination]}' file").yellow
    end

    def overwrite_file_msg(data)
      ColorizedString.new("  Overwrite '#{data[:destination]}' file? [Yn]:").yellow
    end

    def copy_templates_file_exist(data, destination_path, source_path)
      puts_info(ColorizedString.new("Conflict with '#{data[:destination]}' template").yellow)
      print_info(ColorizedString.new("  Overwrite '#{data[:destination]}' template? [Yn]:").yellow)
      copy_templates_overwrite(gets.strip.downcase, data, destination_path, source_path)
    end

    def copy_with_path_file_exist(data, source, destination)
      if FileUtils.identical?(source, destination)
        puts_info("#{ColorizedString.new('Identical').light_green} '#{data[:destination]}' file")
      else
        puts_info(conflict_file_msg(data))
        print_info(overwrite_file_msg(data))
        copy_with_path_overwrite(gets.strip.downcase, data, source, destination)
      end
    end

    def copy_templates_overwrite(answer, data, destination_path, source_path)
      case answer
        when 'y'
          write_template(destination_path, source_path)
          puts_info("    #{ColorizedString.new('Forced').light_green} '#{data[:destination]}' template")
        when 'n'
          puts_info("    #{ColorizedString.new('Skipped').light_black} '#{data[:destination]}' template")
        else nil
      end
    end

    def copy_with_path_overwrite(answer, data, source, destination)
      case answer
        when 'y'
          FileUtils.cp(source, destination)
          puts_info("    #{ColorizedString.new('Forced').light_green} '#{data[:destination]}' file")
        when 'n'
          puts_info("    #{ColorizedString.new('Skipped').light_black} '#{data[:destination]}' file")
        else nil
      end
    end
  end

  # Parent class for all generators
  class BaseGenerator
    attr_reader :options, :args, :project_name

    include Outputable
    include Copyable

    def initialize(options = {}, args = [])
      @options = options.symbolize_keys
      @args = args
      @project_name = args.first
      super()
    end
  end
end
