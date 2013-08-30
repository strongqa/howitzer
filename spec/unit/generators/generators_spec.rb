require 'spec_helper'
require 'fileutils'

Dir[File.join(generators_path, '**', '*_generator.rb')].each{ |f| require f }

describe "Generators" do
  let(:destination) { Dir.mktmpdir }
  let(:output) { StringIO.new }
  subject { file_tree_info(destination) }
  before do
    Howitzer::BaseGenerator.logger = output
    Howitzer::BaseGenerator.destination = destination
    generator_name.new
  end

  after { FileUtils.rm_r(destination) }

  describe "ConfigGenerator" do
    let(:generator_name) { Howitzer::ConfigGenerator }
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
        "      Creates config files.
      Added 'config/custom.yml' file
      Added 'config/default.yml' file\n"
    end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "PagesGenerator" do
    let(:generator_name) { Howitzer::PagesGenerator }
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
        "      Creates PageOriented pattern structure
      Added 'pages/example_page.rb' file
      Added 'pages/example_menu.rb' file\n"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "TasksGenerator" do
    let(:generator_name) { Howitzer::TasksGenerator }
    let(:expected_result) do
      [
          {:name=>"/tasks", :is_directory=>true},
          {:name=>"/tasks/common.rake", :is_directory=>false, :size=>511}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "      Creates RAKE tasks folder and file.
      Added 'tasks/common.rake' file\n"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "EmailsGenerator" do
    let(:generator_name) { Howitzer::EmailsGenerator }
    let(:expected_result) do
      [
          {:name=>"/emails", :is_directory=>true},
          {:name=>"/emails/example_email.rb", :is_directory=>false, :size=>130}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "  Creates a simple email class.\"
      Added '/emails/example_email.rb' file\n"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "RootGenerator" do
    let(:generator_name) { Howitzer::RootGenerator }
    let(:expected_result) do
      [
          {:name=>"/Gemfile", :is_directory=>false, :size=>159},
          {:name=>"/Rakefile", :is_directory=>false, :size=>367},
          {:name=>"/boot.rb", :is_directory=>false, :size=>280}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "      Creates root config files.
      Added '.gitignore' file
      Added 'Gemfile' file
      Added 'Rakefile' file
      Added 'boot.rb' file\n"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "CucumberGenerator" do
    let(:generator_name) { Howitzer::CucumberGenerator }
    let(:expected_result) do
      [
        {:name=>"/config", :is_directory=>true},
        {:name=>"/config/cucumber.yml", :is_directory=>false, :size=>596},
        {:name=>"/features", :is_directory=>true},
        {:name=>"/features/example.feature", :is_directory=>false, :size=>526},
        {:name=>"/features/step_definitions", :is_directory=>true},
        {:name=>"/features/step_definitions/common_steps.rb", :is_directory=>false, :size=>611},
        {:name=>"/features/support", :is_directory=>true},
        {:name=>"/features/support/env.rb", :is_directory=>false, :size=>1192},
        {:name=>"/features/support/transformers.rb", :is_directory=>false, :size=>748},
        {:name=>"/tasks", :is_directory=>true},
        {:name=>"/tasks/cucumber.rake", :is_directory=>false, :size=>1904}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "      Integrates Cucumber to the framework
      Added 'features/step_definitions/common_steps.rb' file
      Added 'features/support/env.rb' file
      Added 'features/support/transformers.rb' file
      Added 'features/example.feature' file
      Added 'tasks/cucumber.rake' file
      Added 'config/cucumber.yml' file\n"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end
  describe "RSpecGenerator" do
    let(:generator_name) { Howitzer::RspecGenerator }
    let(:expected_result) do
      [
          {:name=>"/spec", :is_directory=>true},
          {:name=>"/spec/example_spec.rb", :is_directory=>false, :size=>107},
          {:name=>"/spec/spec_helper.rb", :is_directory=>false, :size=>1767},
          {:name=>"/tasks", :is_directory=>true},
          {:name=>"/tasks/rspec.rake", :is_directory=>false, :size=>951}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "      Integrates RSpec to the framework.
      Added 'spec/spec_helper.rb' file
      Added 'spec/example_spec.rb' file
      Added 'tasks/rspec.rake' file\n"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end


end

