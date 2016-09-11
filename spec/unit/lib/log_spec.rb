require 'spec_helper'
require 'howitzer/log'
include Howitzer::LoggerHelper

RSpec.describe Howitzer::Log do
  context '.instance' do
    subject { described_class.instance }
    let(:other_log) { described_class.instance }
    it { is_expected.to be_a_kind_of(described_class) }
    it { is_expected.to equal(other_log) }
  end

  context '.debug' do
    it do
      expect(described_class.instance).to receive(:debug).with('Foo')
      described_class.debug('Foo')
    end
  end

  context '.info' do
    it do
      expect(described_class.instance).to receive(:info).with('Foo')
      described_class.info('Foo')
    end
  end

  context '.warn' do
    it do
      expect(described_class.instance).to receive(:warn).with('Foo')
      described_class.warn('Foo')
    end
  end

  context '.fatal' do
    it do
      expect(described_class.instance).to receive(:fatal).with('Foo')
      described_class.fatal('Foo')
    end
  end

  context '.error' do
    it do
      expect(described_class.instance).to receive(:error).with('Foo')
      described_class.error('Foo')
    end
  end

  context '.print_feature_name' do
    it do
      expect(described_class.instance).to receive(:print_feature_name).with('Foo')
      described_class.print_feature_name('Foo')
    end
  end

  context '.settings_as_formatted_text' do
    it do
      expect(described_class.instance).to receive(:settings_as_formatted_text).with(no_args)
      described_class.settings_as_formatted_text
    end
  end

  context '.print_scenario_name' do
    it do
      expect(described_class.instance).to receive(:print_scenario_name).with('Foo')
      described_class.print_scenario_name('Foo')
    end
  end

  describe '#debug' do
    it do
      expect(described_class.instance.instance_variable_get(:@logger)).to receive(:debug).with(:foo)
      described_class.instance.debug :foo
    end
  end
  describe '#info' do
    it do
      expect(described_class.instance.instance_variable_get(:@logger)).to receive(:info).with(:foo)
      described_class.instance.info :foo
    end
  end
  describe '#warn' do
    it do
      expect(described_class.instance.instance_variable_get(:@logger)).to receive(:warn).with(:foo)
      described_class.instance.warn :foo
    end
  end
  describe '#fatal' do
    it do
      expect(described_class.instance.instance_variable_get(:@logger)).to receive(:fatal).with(:foo)
      described_class.instance.fatal :foo
    end
  end

  describe '#error' do
    it do
      expect(described_class.instance.instance_variable_get(:@logger)).to receive(:error).with(:foo)
      described_class.instance.error :foo
    end
  end

  describe '#print_feature_name' do
    it do
      expect(described_class.instance).to receive(:log_without_formatting) { |&arg| arg.call }
      expect(described_class.instance).to receive(:info).with('*** Feature: FOO ***')
      described_class.instance.print_feature_name('Foo')
    end
  end
  describe '#settings_as_formatted_text' do
    it do
      expect(described_class.instance).to receive(:log_without_formatting) { |&arg| arg.call }
      expect(described_class.instance).to receive(:info).with(SexySettings::Base.instance.as_formatted_text)
      described_class.instance.settings_as_formatted_text
    end
  end
  describe '#print_scenario_name' do
    it do
      expect(described_class.instance).to receive(:log_without_formatting) { |&arg| arg.call }
      expect(described_class.instance).to receive(:info).with(' => Scenario: Foo')
      described_class.instance.print_scenario_name('Foo')
    end
  end
end
