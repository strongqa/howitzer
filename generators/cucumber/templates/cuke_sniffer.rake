require 'cuke_sniffer'

def path_to_features
  @_path_to_features ||= File.expand_path(File.join(__dir__, '..', 'features'))
end

def cuke_sniffer
  @_cuke_sniffer ||= CukeSniffer::CLI.new(
    features_location: path_to_features,
    step_definitions_location: File.join(path_to_features, 'step_definitions'),
    hooks_location: File.join(path_to_features, 'support'),
    no_catalog: false
  )
end

desc 'Generate cuke_sniffer reports'
task :cuke_sniffer do
  FileUtils.mkdir_p(Howitzer.log_dir)
  cuke_sniffer.output_html("#{Howitzer.log_dir}/cuke_sniffer_results.html")
  cuke_sniffer.output_min_html("#{Howitzer.log_dir}/min_cuke_sniffer_results.html")
end
