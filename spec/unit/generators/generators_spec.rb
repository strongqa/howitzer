require 'spec_helper'
require 'fileutils'
require 'rubigen'
require 'rubigen/scripts/generate'
require_relative '../../../generators/config/config_generator'

describe "Generators" do
  let(:destination) { Dir.mktmpdir }
  let(:output) { StringIO.new }
  subject { file_tree_info(destination) }
  before do
    RubiGen::Base.logger = RubiGen::SimpleLogger.new(output)
    RubiGen::Base.use_application_sources!
    RubiGen::Base.prepend_sources(*[RubiGen::PathSource.new(:app, File.join(File.dirname(__FILE__), "..", "..","..", "generators"))])
    RubiGen::Scripts::Generate.new.run([generator_name], destination: destination)
  end

  after { FileUtils.rm_r(destination) }

  describe "ConfigGenerator" do
    let(:generator_name) { 'config' }
    let(:expected_result) do
      [
          {:name=>"/config", :is_directory=>true},
          {:name=>"/config/custom.yml", :is_directory=>false, :size=>78},
          {:name=>"/config/default.yml", :is_directory=>false, :size=>2780}
      ]
    end

    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "      create  config
      create  /config/custom.yml
      create  /config/default.yml
"
    end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "PagesGenerator" do
    let(:generator_name) { 'pages' }
    let(:expected_result) do
      [
          {:name=>"/pages", :is_directory=>true},
          {:name=>"/pages/example_menu.rb", :is_directory=>false, :size=>447},
          {:name=>"/pages/example_page.rb", :is_directory=>false, :size=>321}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "      create  pages
      create  /pages/example_page.rb
      create  /pages/example_menu.rb
"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "TasksGenerator" do
    let(:generator_name) { 'tasks' }
    let(:expected_result) do
      [
          {:name=>"/tasks", :is_directory=>true},
          {:name=>"/tasks/common.rake", :is_directory=>false, :size=>511}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "      create  tasks
      create  /tasks/common.rake
"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "EmailsGenerator" do
    let(:generator_name) { 'emails' }
    let(:expected_result) do
      [
          {:name=>"/emails", :is_directory=>true},
          {:name=>"/emails/example_email.rb", :is_directory=>false, :size=>130}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "      create  emails
      create  /emails/example_email.rb
"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "RootGenerator" do
    let(:generator_name) { 'root' }
    let(:expected_result) do
      [
          {:name=>"/Gemfile", :is_directory=>false, :size=>189},
          {:name=>"/Rakefile", :is_directory=>false, :size=>367},
          {:name=>"/boot.rb", :is_directory=>false, :size=>280}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "      exists  \n      create  .gitignore
      create  Gemfile
      create  Rakefile
      create  boot.rb
"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "CucumberGenerator" do
    let(:generator_name) { 'cucumber' }
    let(:expected_result) do
      [
          {:name=>"/example.feature", :is_directory=>false, :size=>526},
          {:name=>"/features", :is_directory=>true},
          {:name=>"/step_definitions", :is_directory=>true},
          {:name=>"/step_definitions/common_steps.rb", :is_directory=>false, :size=>611},
          {:name=>"/support", :is_directory=>true},
          {:name=>"/support/env.rb", :is_directory=>false, :size=>1192},
          {:name=>"/support/transformers.rb", :is_directory=>false, :size=>748}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "      create  features
      create  step_definitions
      create  support
      exists  ../tasks
      exists  ../config
      exists  step_definitions
      exists  support
      create  step_definitions/common_steps.rb
      create  support/env.rb
      create  support/transformers.rb
      create  example.feature
   identical  ../tasks/cucumber.rake
   identical  ../config/cucumber.yml
"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "RSpecGenerator" do
    let(:generator_name) { 'rspec' }
    let(:expected_result) do
      [
          {:name=>"/spec", :is_directory=>true},
          {:name=>"/spec/example_spec.rb", :is_directory=>false, :size=>107},
          {:name=>"/spec/spec_helper.rb", :is_directory=>false, :size=>1767}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "      create  spec
      exists  ../tasks
      create  /spec/spec_helper.rb
      create  /spec/example_spec.rb
   identical  ../tasks/rspec.rake
"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end


end

