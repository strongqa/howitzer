require 'spec_helper'
require "#{lib_path}/howitzer/utils/logger"
include LoggerHelper

describe "Logger" do
  let(:path) { File.join(log_path,'log.txt') }
  context "#log" do
    subject { log }
    let(:other_log) { log }
    it { expect(subject).to be_a_kind_of(Log4r::Logger) }
    it { expect(subject).to equal(other_log) }
  end

  context ".print_feature_name" do
    let(:feature) { 'Some feature' }
    let(:expected_result) { "*** Feature: SOME FEATURE ***\n"}
    subject { read_file(path) }
    before { log.print_feature_name(feature) }
    after { clear_file(path) }
    it { expect(subject).to include(expected_result) }
  end

  context ".settings_as_formatted_text" do
    let(:formatted_text) { Faker::Lorem.sentence }
    let(:as_formatted_text) { double() }
    let(:expected_result) { formatted_text }
    subject { read_file(path) }
    before do
      expect(settings).to receive(:as_formatted_text).and_return(formatted_text)
      log.settings_as_formatted_text
    end
    after { clear_file(path) }
    it { expect(subject).to include(expected_result) }
  end

  context ".print_scenario_name" do
    let(:expected_result) { " => Scenario: Some scenario\n" }
    let(:scenario) { 'Some scenario' }
    subject { read_file(path) }
    before { log.print_scenario_name(scenario) }
    after { clear_file(path) }
    it { expect(subject).to include(expected_result) }
  end

  context ".error" do
    context "when exception given as argument" do
      let(:args) { [Exception.new('Exception_error_message')] }
      subject { log.error(*args) }
      it { expect {subject}.to raise_error(Exception, 'Exception_error_message') }
    end

    context "when message given as argument" do
      let(:args) { ['Runtime_error_message'] }
      subject { log.error(*args) }
      it { expect {subject}.to raise_error(RuntimeError, 'Runtime_error_message') }
    end

    context "when two arguments given" do
      let(:args) { ['Some_text','two_args_caller'] }
      subject { log.error(*args) }
      it { expect {subject}.to raise_error(RuntimeError) }
      it { expect(read_file(path)).to include('[ERROR] [RuntimeError] Some_text') }
      it { expect(read_file(path)).to include('two_args_caller') }
    end

    context "when three arguments given" do
      let(:args) { [NameError, 'Name_error_text','three_args_caller'] }
      subject { log.error(*args) }
      it { expect {subject}.to raise_error(NameError) }
      it { expect(read_file(path)).to include('[ERROR] [NameError] Name_error_text') }
      it { expect(read_file(path)).to include('three_args_caller') }
    end
  end
end