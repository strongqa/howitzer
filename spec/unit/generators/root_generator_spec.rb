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

  describe 'RootGenerator' do
    let(:generator_name) { Howitzer::RootGenerator }
    let(:expected_result) do
      [
          {:name=> '/Rakefile', :is_directory=>false, :size=>template_file_size('root', 'Rakefile')},
          {:name=> '/boot.rb', :is_directory=>false, :size=>template_file_size('root', 'boot.rb')}
      ]
    end
    it { is_expected.to eql(expected_result) }
    describe 'output' do
      let(:expected_output) do
        "  * Root files generation ...
      Added '.gitignore' file
      Added 'Rakefile' file
      Added 'boot.rb' file\n"
      end
      subject { output.string }
      it { is_expected.to eql(expected_output) }
    end
  end
end