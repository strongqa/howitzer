require 'spec_helper'

RSpec.describe 'Generators' do
  let(:destination) { Howitzer::BaseGenerator.destination }
  let(:output) { StringIO.new }
  subject { file_tree_info(destination) }
  before do
    Howitzer::BaseGenerator.logger = output
    generator_name.new(rspec: true)
  end
  after { FileUtils.rm_r(destination) }

  describe Howitzer::RspecGenerator do
    let(:generator_name) { described_class }
    let(:expected_result) do
      [
        { name: '/spec', is_directory: true },
        { name: '/spec/example_spec.rb', is_directory: false, size: template_file_size('rspec', 'example_spec.rb') },
        { name: '/spec/spec_helper.rb', is_directory: false, size: template_file_size('rspec', 'spec_helper.rb') },
        { name: '/tasks', is_directory: true },
        { name: '/tasks/rspec.rake', is_directory: false, size: template_file_size('rspec', 'rspec.rake') }
      ]
    end
    it { is_expected.to eql(expected_result) }
    describe 'output' do
      let(:expected_output) do
        "  * RSpec integration to the framework ...
      Added 'spec/spec_helper.rb' file
      Added 'spec/example_spec.rb' file
      Added 'tasks/rspec.rake' file\n"
      end
      subject { output.string }
      it { is_expected.to eql(expected_output) }
    end
  end
end
