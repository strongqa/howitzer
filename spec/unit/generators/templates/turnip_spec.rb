require 'spec_helper'

RSpec.describe Howitzer::BaseGenerator do
  describe 'Template rendering' do
    context 'when turnip' do
      subject { ERB.new(template, trim_mode: '-').result(binding) }
      let(:cucumber) { false }
      let(:rspec) { false }
      let(:turnip) { true }
      let(:template) { File.read(source_path) }

      context '.rubocop.yml' do
        let(:source_path) { File.join('generators', 'root', 'templates', '.rubocop.yml.erb') }
        it do
          res = <<~EXPECTED_CONTENT
            # See full list of defaults here: https://github.com/bbatsov/rubocop/blob/master/config/default.yml
            # To see all cops used see here: https://github.com/bbatsov/rubocop/blob/master/config/enabled.yml
            require: rubocop-rspec

            AllCops:
              DisplayCopNames: true
              NewCops: enable
              TargetRubyVersion: 3

            Layout/CaseIndentation:
              Enabled: false

            Layout/LineLength:
              Max: 120

            Lint/AmbiguousRegexpLiteral:
              Enabled: false

            Metrics/BlockLength:
              Enabled: false

            Metrics/ModuleLength:
              Max: 150

            Style/CaseEquality:
              Enabled: false

            Style/Documentation:
              Enabled: false

            Style/EmptyElse:
              Enabled: false

            Style/FrozenStringLiteralComment:
              Enabled: false

            Style/MixinGrouping:
              EnforcedStyle: separated
              Exclude:
                - '**/*_steps.rb'

            Style/SymbolProc:
              Exclude:
                - 'spec/steps/**/*.rb'

            RSpec/Capybara/FeatureMethods:
              Enabled: false

            RSpec/ExampleLength:
              Max: 40

            RSpec/MultipleExpectations:
              Max: 8
          EXPECTED_CONTENT
          is_expected.to eq(res)
        end
      end

      context 'Gemfile' do
        let(:source_path) { File.join('generators', 'root', 'templates', 'Gemfile.erb') }
        it do
          res = <<~EXPECTED_CONTENT
            source 'https://rubygems.org'

            ruby '>=2.6.8'

            gem 'capybara-screenshot'
            gem 'factory_bot'
            gem 'howitzer'
            gem 'pry'
            gem 'pry-byebug'
            gem 'repeater'
            gem 'rest-client'
            gem 'rspec', '~>3.2'
            gem 'rubocop'
            gem 'rubocop-rspec'
            gem 'turnip'
          EXPECTED_CONTENT
          is_expected.to eq(res)
        end
      end
    end
  end
end
