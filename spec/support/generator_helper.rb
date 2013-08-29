module GeneratorHelper
  def file_tree_info(root)
    Dir["#{root}/**/*"].sort_by{|name| name.sub(root, '') }.map do |name|
      hash = {name: name.sub(root, ''), is_directory: File.directory?(name)}
      hash[:size] = File.stat(name).size unless hash[:is_directory]
      hash
    end
  end
end