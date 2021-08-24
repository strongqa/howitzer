require 'fileutils'
require_relative '../../generators/base_generator'

module Howitzer
  module GeneratorHelper
    def file_tree_info(root)
      Dir["#{root}/**/.*", "#{root}/**/*"].sort_by { |name| name.sub(root, '') }.map do |name|
        hash = { name: name.sub(root, ''), is_directory: File.directory?(name) }
        hash[:size] = File.stat(name).size unless hash[:is_directory]
        hash
      end
    end

    def template_file_size(root_directory, file)
      File.size(File.join(generators_path, root_directory, 'templates', file))
    end
  end
end
Howitzer::BaseGenerator.logger = StringIO.new
Howitzer::BaseGenerator.destination = Dir.mktmpdir
Dir[File.join(generators_path, '**', '*_generator.rb')].sort.each { |f| require f }
