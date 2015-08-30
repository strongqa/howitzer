require 'spec_helper'

RSpec.describe 'Generators' do
  let(:destination) { Howitzer::BaseGenerator.destination }
  let(:output) { StringIO.new }
  subject { file_tree_info(destination) }
  before do
    Howitzer::BaseGenerator.logger = output
    generator_name.new(options)
  end
  after { FileUtils.rm_r(destination) }

  describe 'RootGenerator' do
    let(:generator_name) { Howitzer::RootGenerator }
    let(:expected_result) do
      [
          {:name=> '/Gemfile', :is_directory=>false, :size=>593},
          {:name=> '/Rakefile', :is_directory=>false, :size=>template_file_size('root', 'Rakefile')},
          {:name=> '/boot.rb', :is_directory=>false, :size=>template_file_size('root', 'boot.rb')}
      ]
    end
    let(:options) { {} }
    it { is_expected.to eql(expected_result) }
    describe 'output' do
      subject { output.string }
      context 'when options is empty' do
        let(:expected_output) do
          "  * Root files generation ...
      Added '.gitignore' file
      Added 'Rakefile' file
      Added 'boot.rb' file
      Added template 'Gemfile.erb' with params '{}' to destination 'Gemfile'\n"
        end
        it { is_expected.to eql(expected_output) }
      end
      context 'when options is rspec => true' do
        let(:expected_output) do
          "  * Root files generation ...
      Added '.gitignore' file
      Added 'Rakefile' file
      Added 'boot.rb' file
      Added template 'Gemfile.erb' with params '{:rspec=>true}' to destination 'Gemfile'\n"
        end
        let(:options) { {rspec: true} }
        it { is_expected.to eql(expected_output) }
      end
      context 'when options is cucumber => cucumber' do
        let(:expected_output) do
          "  * Root files generation ...
      Added '.gitignore' file
      Added 'Rakefile' file
      Added 'boot.rb' file
      Added template 'Gemfile.erb' with params '{:cucumber=>true}' to destination 'Gemfile'\n"
        end
        let(:options) { {cucumber: true} }
        it { is_expected.to eql(expected_output) }
      end
    end
  end
end