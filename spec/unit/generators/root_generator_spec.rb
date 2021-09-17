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

  describe Howitzer::RootGenerator do
    let(:generator_name) { described_class }
    let(:expected_result) do
      [
        { name: '/.gitignore', is_directory: false, size: 196 },
        { name: '/.rubocop.yml', is_directory: false, size: 631 },
        { name: '/Gemfile', is_directory: false, size: 367 },
        { name: '/Rakefile', is_directory: false, size: template_file_size('root', 'Rakefile') }
      ]
    end
    let(:options) { {} }

    it { is_expected.to eql(expected_result) }

    describe 'output' do
      subject { output.string }

      context 'when options is empty' do
        let(:expected_output) do
          added_text = ColorizedString.new('Added').light_green
          "#{ColorizedString.new('  * Root files generation ...').light_cyan}
      #{added_text} '.gitignore' file
      #{added_text} 'Rakefile' file
      #{added_text} template '.rubocop.yml.erb' with params '{}' to destination '.rubocop.yml'
      #{added_text} template 'Gemfile.erb' with params '{}' to destination 'Gemfile'\n"
        end

        it { is_expected.to eql(expected_output) }
      end

      context 'when options is rspec => true' do
        let(:expected_output) do
          added_text = ColorizedString.new('Added').light_green
          "#{ColorizedString.new('  * Root files generation ...').light_cyan}
      #{added_text} '.gitignore' file
      #{added_text} 'Rakefile' file
      #{added_text} template '.rubocop.yml.erb' with params '{:rspec=>true}' to destination '.rubocop.yml'
      #{added_text} template 'Gemfile.erb' with params '{:rspec=>true}' to destination 'Gemfile'\n"
        end
        let(:options) { { rspec: true } }

        it { is_expected.to eql(expected_output) }
      end

      context 'when options is cucumber => cucumber' do
        let(:expected_output) do
          added_text = ColorizedString.new('Added').light_green
          "#{ColorizedString.new('  * Root files generation ...').light_cyan}
      #{added_text} '.gitignore' file
      #{added_text} 'Rakefile' file
      #{added_text} template '.rubocop.yml.erb' with params '{:cucumber=>true}' to destination '.rubocop.yml'
      #{added_text} template 'Gemfile.erb' with params '{:cucumber=>true}' to destination 'Gemfile'\n"
        end
        let(:options) { { cucumber: true } }

        it { is_expected.to eql(expected_output) }
      end

      context 'when options is turnip => true' do
        let(:expected_output) do
          added_text = ColorizedString.new('Added').light_green
          "#{ColorizedString.new('  * Root files generation ...').light_cyan}
      #{added_text} '.gitignore' file
      #{added_text} 'Rakefile' file
      #{added_text} template '.rubocop.yml.erb' with params '{:turnip=>true}' to destination '.rubocop.yml'
      #{added_text} template 'Gemfile.erb' with params '{:turnip=>true}' to destination 'Gemfile'\n"
        end
        let(:options) { { turnip: true } }

        it { is_expected.to eql(expected_output) }
      end
    end
  end
end
