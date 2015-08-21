require 'rspec'
require 'rspec/core/rake_task'
include RSpec::Core

# Specify here your group tests
TEST_TYPES = [:all, :health, :bvt, :p1]

# Specify here your business areas, ex. [:accounts, :blog, :news]
TEST_AREAS = []

namespace :rspec do
  std_opts = "--format html --out=./#{settings.log_dir}/#{settings.html_log} --format documentation --color"
  TEST_TYPES.each do |type|
    RakeTask.new(type) do |s|
      s.send :desc, "Run all #{"'#{s.name}' " unless type == :all}tests"
      s.pattern = "./spec/#{type == :all ? '**': s.name}/**/*_spec.rb"
      s.rspec_opts = std_opts
      s.verbose = true
    end
    TEST_AREAS.each do |group|
      type_text = type == :all ? '**': type
      pattern = "./spec/#{type_text}/#{group}/**/*_spec.rb"
      RakeTask.new("#{"#{type}:" unless type == :all}#{group}") do |s|
        s.send :desc, "Run all '#{s.name}' tests"
        s.pattern = pattern
        s.rspec_opts = std_opts
        s.verbose = true
      end
    end
  end

end

task default: "rspec:all"
