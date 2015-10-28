require 'fileutils'
require 'erb'
require 'ostruct'
require 'active_support/core_ext/hash'

module Howitzer
  class BaseGenerator
    class << self
      attr_accessor :logger, :destination
    end

    def initialize(options)
      @options = options.symbolize_keys
      print_banner
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

    def manifest; end

    protected

    def banner; end

    def logger
      BaseGenerator.logger || $stdout
    end

    def destination
      BaseGenerator.destination || Dir.pwd
    end

    def copy_files(list)
      list.each do |data|
        source_file = source_path(data[:source])

        if File.exist?(source_file)
          copy_with_path(data)
        else
          puts_error("File '#{source_file}' was not found.")
        end
      end
    end

    def copy_templates(list)
      list.each do |data|
        destination_path = dest_path(data[:destination])
        source_path = source_path(data[:source])
        if File.exist?(destination_path)
          puts_info("Conflict with '#{data[:destination]}' template")
          print_info("  Overwrite '#{data[:destination]}' template? [Yn]:")
          case gets.strip.downcase
            when 'y'
              write_template(destination_path, source_path)
              puts_info("    Forced '#{data[:destination]}' template")
            when 'n' then nil
              puts_info("    Skipped '#{data[:destination]}' template")
            else nil
          end
        else
          write_template(destination_path, source_path)
          puts_info "Added template '#{data[:source]}' with params '#{@options}' to destination '#{data[:destination]}'"
        end
      end
    end

    def print_banner
      logger.puts banner unless banner.empty?
    end

    def print_info(data)
      logger.print "      #{data}"
    end

    def puts_info(data)
      logger.puts "      #{data}"
    end

    def puts_error(data)
      logger.puts "      ERROR: #{data}"
    end

    def source_path(file_name)
      base_name = self.class.name.sub('Generator', '').sub('Howitzer::', '').downcase
      File.expand_path(file_name, File.join(File.dirname(__FILE__), base_name, 'templates'))
    end

    def dest_path(path)
      File.expand_path(File.join(destination, path))
    end

    def copy_with_path(data)
      src = source_path(data[:source])
      dst = dest_path(data[:destination])
      FileUtils.mkdir_p(File.dirname(dst))
      if File.exist?(dst)
        if FileUtils.identical?(src, dst)
          puts_info("Identical '#{data[:destination]}' file")
        else
          puts_info("Conflict with '#{data[:destination]}' file")
          print_info("  Overwrite '#{data[:destination]}' file? [Yn]:")
          case gets.strip.downcase
            when 'y'
              FileUtils.cp(src, dst)
              puts_info("    Forced '#{data[:destination]}' file")
            when 'n' then nil
              puts_info("    Skipped '#{data[:destination]}' file")
            else nil
          end
        end
      else
        FileUtils.cp(src, dst)
        puts_info("Added '#{data[:destination]}' file")
      end
    rescue => e
      puts_error("Impossible to create '#{data[:destination]}' file. Reason: #{e.message}")
    end

    def write_template(dest_path, source_path)
      File.open(dest_path, 'w+'){|f|
        f.write(
          ERB.new(File.open(source_path, 'r').read).result(OpenStruct.new(@options).instance_eval { binding })
        )
      }
    end
  end
end
