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

  describe 'TurnipGenerator' do
    let(:generator_name) { Howitzer::TurnipGenerator }
    let(:expected_result) do
      [
          {:name=> '/spec', :is_directory=>true},
          {:name=> '/spec/acceptance', :is_directory=>true},
          {:name=> '/spec/acceptance/example.feature', :is_directory=>false, :size=>template_file_size('turnip', 'example.feature')},
          {:name=> '/spec/spec_helper.rb', :is_directory=>false, :size=>template_file_size('turnip', 'spec_helper.rb')},
          {:name=> '/spec/steps', :is_directory=>true},
          {:name=> '/spec/steps/common_steps.rb', :is_directory=>false, :size=>template_file_size('turnip', 'common_steps.rb')},
          {:name=> '/spec/turnip_helper.rb', :is_directory=>false, :size=>template_file_size('turnip', 'turnip_helper.rb')},
          {:name=> '/tasks', :is_directory=>true},
          {:name=> '/tasks/turnip.rake', :is_directory=>false, :size=>template_file_size('rspec', 'rspec.rake')}
      ]
    end
    it { is_expected.to eql(expected_result) }
    describe 'output' do
      let(:expected_output) do
        "  * Turnip integration to the framework ...
      Added '.rspec' file
      Added 'spec/spec_helper.rb' file
      Added 'spec/turnip_helper.rb' file
      Added 'spec/acceptance/example.feature' file
      Added 'spec/steps/common_steps.rb' file
      Added 'tasks/turnip.rake' file\n"
      end
      subject { output.string }
      it { is_expected.to eql(expected_output) }
    end
  end
end