require 'spec_helper'

RSpec.describe 'Generators' do
  let(:destination) { Howitzer::BaseGenerator.destination }
  let(:output) { StringIO.new }
  subject { file_tree_info(destination) }
  before do
    Howitzer::BaseGenerator.logger = output
    generator_name.new
  end
  after { FileUtils.rm_r(destination) }

  describe 'CucumberGenerator' do
    let(:generator_name) { Howitzer::CucumberGenerator }
    let(:expected_result) do
      [
          {:name=> '/config', :is_directory=>true},
          {:name=> '/config/cucumber.yml', :is_directory=>false, :size=>template_file_size('cucumber', 'cucumber.yml')},
          {:name=> '/features', :is_directory=>true},
          {:name=> '/features/example.feature', :is_directory=>false, :size=>template_file_size('cucumber', 'example.feature')},
          {:name=> '/features/step_definitions', :is_directory=>true},
          {:name=> '/features/step_definitions/common_steps.rb', :is_directory=>false, :size=>template_file_size('cucumber', 'common_steps.rb')},
          {:name=> '/features/support', :is_directory=>true},
          {:name=> '/features/support/env.rb', :is_directory=>false, :size=>template_file_size('cucumber', 'env.rb')},
          {:name=> '/features/support/transformers.rb', :is_directory=>false, :size=>template_file_size('cucumber', 'transformers.rb')},
          {:name=> '/tasks', :is_directory=>true},
          {:name=> '/tasks/cucumber.rake', :is_directory=>false, :size=>template_file_size('cucumber', 'cucumber.rake')}
      ]
    end
    it { is_expected.to eql(expected_result) }
    describe 'output' do
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
      it { is_expected.to eql(expected_output) }
    end
  end
end