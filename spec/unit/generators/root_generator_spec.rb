require 'spec_helper'

RSpec.describe 'Generators' do
  let(:destination) { Howitzer::BaseGenerator.destination }
  let(:output) { StringIO.new }
  subject { file_tree_info(destination) }
  before do
    Howitzer::BaseGenerator.logger = output
    generator_name.new(options, args)
  end
  after { FileUtils.rm_r(destination) }

  describe Howitzer::RootGenerator do
    let(:generator_name) { described_class }
    let(:expected_result) do
      [
        { name: '/.dockerignore', is_directory: false, size: template_file_size('root', '.dockerignore') },
        { name: '/.gitignore', is_directory: false, size: template_file_size('root', '.gitignore') },
        { name: '/.rubocop.yml', is_directory: false, size: template_file_size('root', '.rubocop.yml.erb') },
        { name: '/Dockerfile', is_directory: false, size: template_file_size('root', 'Dockerfile') },
        { name: '/Gemfile', is_directory: false, size: template_file_size('root', 'Gemfile.erb') },
        { name: '/README.md', is_directory: false, size: template_file_size('root', 'README.md.erb') },
        { name: '/Rakefile', is_directory: false, size: template_file_size('root', 'Rakefile') },
        { name: '/docker-compose.yml', is_directory: false, size: template_file_size('root', 'docker-compose.yml.erb') }
      ]
    end
    let(:options) { {} }
    let(:args) { [] }

    it { is_expected.to eql(expected_result) }

    describe 'output' do
      subject { output.string }

      context 'when options and args are empty' do
        let(:expected_output) do
          added_text = ColorizedString.new('Added').light_green
          "#{ColorizedString.new('  * Root files generation ...').light_cyan}
      #{added_text} '.gitignore' file
      #{added_text} '.dockerignore' file
      #{added_text} 'Dockerfile' file
      #{added_text} 'Rakefile' file
      #{added_text} template '.rubocop.yml.erb' with params '{}' to destination '.rubocop.yml'
      #{added_text} template 'docker-compose.yml.erb' with params '{}' to destination 'docker-compose.yml'
      #{added_text} template 'Gemfile.erb' with params '{}' to destination 'Gemfile'
      #{added_text} template 'README.md.erb' with params '{}' to destination 'README.md'\n"
        end

        it { is_expected.to eql(expected_output) }
      end

      context 'when options is rspec => true and args is [:xxx]' do
        let(:params) { '{:rspec=>true, :project_name=>:xxx}' }
        let(:expected_output) do
          added_text = ColorizedString.new('Added').light_green
          "#{ColorizedString.new('  * Root files generation ...').light_cyan}
      #{added_text} '.gitignore' file
      #{added_text} '.dockerignore' file
      #{added_text} 'Dockerfile' file
      #{added_text} 'Rakefile' file
      #{added_text} template '.rubocop.yml.erb' with params '#{params}' to destination '.rubocop.yml'
      #{added_text} template 'docker-compose.yml.erb' with params '#{params}' to destination 'docker-compose.yml'
      #{added_text} template 'Gemfile.erb' with params '#{params}' to destination 'Gemfile'
      #{added_text} template 'README.md.erb' with params '#{params}' to destination 'README.md'\n"
        end
        let(:options) { { rspec: true } }
        let(:args) { [:xxx] }

        it { is_expected.to eql(expected_output) }
      end

      context 'when options is cucumber => cucumber' do
        let(:params) { '{:cucumber=>true, :project_name=>:xxx}' }
        let(:expected_output) do
          added_text = ColorizedString.new('Added').light_green
          "#{ColorizedString.new('  * Root files generation ...').light_cyan}
      #{added_text} '.gitignore' file
      #{added_text} '.dockerignore' file
      #{added_text} 'Dockerfile' file
      #{added_text} 'Rakefile' file
      #{added_text} template '.rubocop.yml.erb' with params '#{params}' to destination '.rubocop.yml'
      #{added_text} template 'docker-compose.yml.erb' with params '#{params}' to destination 'docker-compose.yml'
      #{added_text} template 'Gemfile.erb' with params '#{params}' to destination 'Gemfile'
      #{added_text} template 'README.md.erb' with params '#{params}' to destination 'README.md'\n"
        end
        let(:options) { { cucumber: true } }
        let(:args) { [:xxx] }

        it { is_expected.to eql(expected_output) }
      end

      context 'when options is turnip => true' do
        let(:params) { '{:turnip=>true, :project_name=>:xxx}' }
        let(:expected_output) do
          added_text = ColorizedString.new('Added').light_green
          "#{ColorizedString.new('  * Root files generation ...').light_cyan}
      #{added_text} '.gitignore' file
      #{added_text} '.dockerignore' file
      #{added_text} 'Dockerfile' file
      #{added_text} 'Rakefile' file
      #{added_text} template '.rubocop.yml.erb' with params '#{params}' to destination '.rubocop.yml'
      #{added_text} template 'docker-compose.yml.erb' with params '#{params}' to destination 'docker-compose.yml'
      #{added_text} template 'Gemfile.erb' with params '#{params}' to destination 'Gemfile'
      #{added_text} template 'README.md.erb' with params '#{params}' to destination 'README.md'\n"
        end
        let(:options) { { turnip: true } }
        let(:args) { [:xxx] }

        it { is_expected.to eql(expected_output) }
      end
    end
  end
end
