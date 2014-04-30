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
          {:name=>"/config/custom.yml", :is_directory=>false, :size=>template_file_size('config', 'custom.yml')},
          {:name=>"/config/default.yml", :is_directory=>false, :size=>template_file_size('config', 'default.yml')}
      ]
    end

    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "  * Config files generation ...
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
          {:name=>"/pages/example_menu.rb", :is_directory=>false, :size=>template_file_size('pages', 'example_menu.rb')},
          {:name=>"/pages/example_page.rb", :is_directory=>false, :size=>template_file_size('pages', 'example_page.rb')}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "  * PageOriented pattern structure generation ...
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
          {:name=>"/tasks/common.rake", :is_directory=>false, :size=>template_file_size('tasks', 'common.rake')}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "  * Base rake task generation ...
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
          {:name=>"/emails/example_email.rb", :is_directory=>false, :size=>template_file_size('emails', 'example_email.rb')}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "  * Email example generation ...
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
          {:name=>"/Gemfile", :is_directory=>false, :size=>template_file_size('root', 'Gemfile')},
          {:name=>"/Rakefile", :is_directory=>false, :size=>template_file_size('root', 'Rakefile')},
          {:name=>"/boot.rb", :is_directory=>false, :size=>template_file_size('root', 'boot.rb')}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "  * Root files generation ...
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
        {:name=>"/config/cucumber.yml", :is_directory=>false, :size=>template_file_size('cucumber', 'cucumber.yml')},
        {:name=>"/features", :is_directory=>true},
        {:name=>"/features/example.feature", :is_directory=>false, :size=>template_file_size('cucumber', 'example.feature')},
        {:name=>"/features/step_definitions", :is_directory=>true},
        {:name=>"/features/step_definitions/common_steps.rb", :is_directory=>false, :size=>template_file_size('cucumber', 'common_steps.rb')},
        {:name=>"/features/support", :is_directory=>true},
        {:name=>"/features/support/env.rb", :is_directory=>false, :size=>template_file_size('cucumber', 'env.rb')},
        {:name=>"/features/support/transformers.rb", :is_directory=>false, :size=>template_file_size('cucumber', 'transformers.rb')},
        {:name=>"/tasks", :is_directory=>true},
        {:name=>"/tasks/cucumber.rake", :is_directory=>false, :size=>template_file_size('cucumber', 'cucumber.rake')}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "  * Cucumber integration to the framework ...
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
          {:name=>"/spec/example_spec.rb", :is_directory=>false, :size=>template_file_size('rspec', 'example_spec.rb')},
          {:name=>"/spec/spec_helper.rb", :is_directory=>false, :size=>template_file_size('rspec', 'spec_helper.rb')},
          {:name=>"/tasks", :is_directory=>true},
          {:name=>"/tasks/rspec.rake", :is_directory=>false, :size=>template_file_size('rspec', 'rspec.rake')}
      ]
    end
    it { expect(subject).to eql(expected_result) }
    describe "output" do
      let(:expected_output) do
        "  * RSpec integration to the framework ...
      Added 'spec/spec_helper.rb' file
      Added 'spec/example_spec.rb' file
      Added 'tasks/rspec.rake' file\n"
      end
      subject { output.string }
      it { expect(subject).to eql(expected_output) }
    end
  end


end

