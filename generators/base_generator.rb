require 'fileutils'

module Howitzer
  class BaseGenerator
    def self.logger=(logger)
      @logger = logger
    end

    def self.destination=(destination)
      @destination = destination
    end

    def initialize
      print_banner
      manifest.each do |type, list|
        case type
          when :files
            copy_files(list)
          #:nocov:
          when :templates
            copy_templates(list)
          else nil
          #:nocov:
        end
      end
    end

    def manifest; end

    protected
    def banner; end

    def logger
      BaseGenerator.instance_variable_get(:@logger) || $stdout
    end

    def destination
      BaseGenerator.instance_variable_get(:@destination) || Dir.pwd
    end

    def copy_files(list)
      list.each do |data|
        source_file = source_path(data[:source])

        if File.exists?(source_file)
          copy_with_path(data)
        else
          print_error("File '#{source_file}' was not found.")
        end
      end
    end

    def copy_templates(list)
      #TODO implement me if it is require
    end

    def print_banner
      logger.puts banner unless banner.empty?
    end

    def print_info(data)
      logger.puts "      #{data}"
    end

    def print_error(data)
      logger.puts "      ERROR: #{data}"
    end

    def source_path(file_name)
      File.expand_path(
          file_name, File.join(File.dirname(__FILE__), self.class.name.sub('Generator', '').sub('Howitzer::', '').downcase, 'templates')
      )
    end

    def dest_path(path)
      File.expand_path(File.join(destination, path))
    end

    def copy_with_path(data)
      src = source_path(data[:source])
      dst = dest_path(data[:destination])
      FileUtils.mkdir_p(File.dirname(dst))
      FileUtils.cp(src, dst)
      print_info("Added '#{data[:destination]}' file")
    rescue => e
      print_error("Impossible to create '#{data[:destination]}' file. Reason: #{e.message}")
    end
  end
end