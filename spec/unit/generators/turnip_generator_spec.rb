require 'spec_helper'

RSpec.describe 'Generators' do
  let(:destination) { Howitzer::BaseGenerator.destination }
  let(:output) { StringIO.new }
  subject { file_tree_info(destination) }
  before do
    Howitzer::BaseGenerator.logger = output
    generator_name.new(turnip: true)
  end
  after { FileUtils.rm_r(destination) }

  describe Howitzer::TurnipGenerator do
    let(:generator_name) { described_class }
    let(:expected_result) do
      [
        { name: '/.rspec', is_directory: false, size: 15 },
        { name: '/spec', is_directory: true },
        { name: '/spec/acceptance', is_directory: true },
        {
          name: '/spec/acceptance/example.feature',
          is_directory: false,
          size: template_file_size('turnip', 'example.feature')
        },
        { name: '/spec/spec_helper.rb', is_directory: false, size: template_file_size('turnip', 'spec_helper.rb') },
        { name: '/spec/steps', is_directory: true },
        {
          name: '/spec/steps/common_steps.rb',
          is_directory: false,
          size: template_file_size('turnip', 'common_steps.rb')
        },
        { name: '/spec/turnip_helper.rb', is_directory: false, size: template_file_size('turnip', 'turnip_helper.rb') },
        { name: '/tasks', is_directory: true },
        { name: '/tasks/turnip.rake', is_directory: false, size: template_file_size('turnip', 'turnip.rake') }
      ]
    end
    it { is_expected.to eql(expected_result) }
    describe 'output' do
      let(:expected_output) do
        "#{ColorizedString.new('  * Turnip integration to the framework ...').light_cyan}
      #{ColorizedString.new('Added').light_green} '.rspec' file
      #{ColorizedString.new('Added').light_green} 'spec/spec_helper.rb' file
      #{ColorizedString.new('Added').light_green} 'spec/turnip_helper.rb' file
      #{ColorizedString.new('Added').light_green} 'spec/acceptance/example.feature' file
      #{ColorizedString.new('Added').light_green} 'spec/steps/common_steps.rb' file
      #{ColorizedString.new('Added').light_green} 'tasks/turnip.rake' file\n"
      end
      subject { output.string }
      it { is_expected.to eql(expected_output) }
    end
  end
end
