require 'spec_helper'
require 'howitzer/utils/log'
include LoggerHelper

describe 'Logger' do
  let(:path) { File.join(log_path,'log.txt') }
  context '#log' do
    subject { log }
    let(:other_log) { Howitzer::Log.instance }
    it { is_expected.to be_a_kind_of(Howitzer::Log) }
    it { is_expected.to equal(other_log) }
  end

  context '.print_feature_name' do
    let(:feature) { 'Some feature' }
    let(:expected_result) { "*** Feature: SOME FEATURE ***\n"}
    subject { read_file(path) }
    before { log.print_feature_name(feature) }
    after { clear_file(path) }
    it { is_expected.to include(expected_result) }
  end

  context '.settings_as_formatted_text' do
    let(:formatted_text) { Faker::Lorem.sentence }
    let(:as_formatted_text) { double }
    let(:expected_result) { formatted_text }
    subject { read_file(path) }
    before do
      expect(settings).to receive(:as_formatted_text).and_return(formatted_text)
      log.settings_as_formatted_text
    end
    after { clear_file(path) }
    it { is_expected.to include(expected_result) }
  end

  context '.print_scenario_name' do
    let(:expected_result) { " => Scenario: Some scenario\n" }
    let(:scenario) { 'Some scenario' }
    subject { read_file(path) }
    before { log.print_scenario_name(scenario) }
    after { clear_file(path) }
    it { is_expected.to include(expected_result) }
  end

  context '.error' do
    context 'when one argument given' do
      subject { log.error(*args) }
      context 'when exception given as argument' do
        let(:args) { [StandardError.new('Exception_error_message')] }
        it { expect {subject}.to raise_error(StandardError, 'Exception_error_message') }
      end
      context 'when message given as argument' do
        let(:args) { ['Runtime_error_message'] }
        it { expect {subject}.to raise_error(RuntimeError, 'Runtime_error_message') }
      end
      context 'when error object given as arg ' do
        let(:error_object) { ErrorObject = StandardError.new }
        let(:args) { error_object }
        it { expect {subject}.to raise_error(StandardError) }
        it { expect(read_file(path)).to include('[ERROR] [StandardError] StandardError') }
      end
      context 'when number given as arg' do
        let(:args) { 123 }
        it { expect {subject}.to raise_error(RuntimeError) }
      end
    end
    context 'when two arguments given' do
      subject { log.error(*args) }
      context 'when given text as first arg and caller as second' do
        let(:args) { %w(Some_text two_args_caller) }
        it { expect {subject}.to raise_error(RuntimeError) }
        it { expect(read_file(path)).to include('[ERROR] [RuntimeError] Some_text') }
        it { expect(read_file(path)).to include('two_args_caller') }
      end
      context 'when given class inherited from Exception as first arg and message as second' do
        let(:error_class) {SomeError = Class.new(Exception) }
        let(:args) { [error_class, 'some text'] }
        it { expect { subject }.to raise_error(error_class, 'some text') }
        it { expect(read_file(path)).to include('[ERROR] [SomeError] some text') }
      end
      context 'when given some class as first arg and (message) as second' do
        let(:some_class) { SomeClass = Class.new }
        let(:args) { [some_class, 'some text'] }
        it { expect{subject}.to raise_error(RuntimeError) }
        it { expect(read_file(path)).to include("[ERROR] [RuntimeError] SomeClass\n\tsome text") }
      end
      context 'when number given as first arg and message as second' do
        let(:args) { [123, 'some text' ] }
        it { expect{subject}.to raise_error(RuntimeError) }
        it { expect(read_file(path)).to include("[ERROR] [RuntimeError] 123\n\tsome text") }
      end
      context 'when nubmers given as args' do
        let(:args) { [123,123] }
        it { expect{subject}.to raise_error(TypeError) }
      end
    end
    context 'when three arguments given' do
      subject { log.error(*args) }
      context 'when NameError given as first arg, message as second and caller as third' do
        let(:args) { [NameError, 'Name_error_text', 'three_args_caller'] }
        it { expect {subject}.to raise_error(NameError) }
        it { expect(read_file(path)).to include('[ERROR] [NameError] Name_error_text') }
        it { expect(read_file(path)).to include('three_args_caller') }
      end
    end
  end
end