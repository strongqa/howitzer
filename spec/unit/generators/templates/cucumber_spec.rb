require 'spec_helper'

RSpec.describe Howitzer::BaseGenerator do
  describe 'Template rendering' do
    context 'when cucumber' do
      subject { ERB.new(template, trim_mode: '-').result(binding) }
      let(:cucumber) { true }
      let(:rspec) { false }
      let(:turnip) { false }
      let(:template) { File.open(source_path, 'r').read }

      context '.rubocop.yml' do
        let(:source_path) { File.join('generators', 'root', 'templates', '.rubocop.yml.erb') }
        it do
          res = <<~EXPECTED_CONTENT
            # See full list of defaults here: https://github.com/bbatsov/rubocop/blob/master/config/default.yml
            # To see all cops used see here: https://github.com/bbatsov/rubocop/blob/master/config/enabled.yml

            AllCops:
              DisplayCopNames: true
              NewCops: enable
              TargetRubyVersion: 3

            Layout/CaseIndentation:
              Enabled: false

            Layout/LineLength:
              Max: 120

            Lint/AmbiguousBlockAssociation:
              Enabled: false

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

            Style/SymbolProc:
              Exclude:
                - 'features/step_definitions/**/*.rb'
          EXPECTED_CONTENT
          is_expected.to eq(res)
        end
      end

      context 'Gemfile' do
        let(:source_path) { File.join('generators', 'root', 'templates', 'Gemfile.erb') }
        it do
          res = <<~EXPECTED_CONTENT
            source 'https://rubygems.org'

            gem 'capybara-screenshot'
            gem 'cucumber', '~>3.0'
            gem 'cuke_sniffer', require: false
            gem 'factory_bot'
            gem 'howitzer'
            gem 'pry'
            gem 'pry-byebug'
            gem 'repeater'
            gem 'rest-client'
            gem 'rubocop'
            gem 'syntax'

            # Uncomment it if you are going to use 'appium' driver. Appium and Android SDK should be installed.
            # See https://appium.io/docs/en/about-appium/getting-started/
            # gem 'appium_capybara'
          EXPECTED_CONTENT
          is_expected.to eq(res)
        end
      end
    end
  end
end
