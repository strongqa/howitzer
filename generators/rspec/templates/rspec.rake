require 'rspec'

include RSpec::Core

TEST_TYPES = [:all, :health, :bvt, :p1]
TEST_AREAS = [:accounts, :api]

namespace :rspec do

  TEST_TYPES.each do |type|
    RakeTask.new(type) do |s|
      s.send :desc, "Run all #{"'#{s.name}' " unless type == :all}tests"
      s.pattern = "./spec/#{type == :all ? '*': s.name}/**/*_spec.rb"
    end
    TEST_AREAS.each do |group|
      type_text = type == :all ? '*': type
      pattern = "./spec/#{type_text}/#{group}/**/*_spec.rb"
      RakeTask.new("#{"#{type}:" unless type == :all}#{group}") do |s|
        s.send :desc, "Run all '#{s.name}' tests"
        s.pattern = pattern
      end
    end
  end

end

task default: "rspec:all"