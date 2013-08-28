module GeneratorHelper
  def file_tree_info(root)
    Dir["#{root}/**/*"].sort.map do |name|
      {name: name.sub(root, ''), is_directory: File.directory?(name), size: File.stat(name).size}
    end
  end
end