module Howitzer
  module LoggerHelper
    def read_file(file)
      path = File.expand_path(file, __FILE__)
      File.read(path)
    end

    def clear_file(file)
      path = File.expand_path(file, __FILE__)
      File.open(path, 'w') { nil }
    end
  end
end
