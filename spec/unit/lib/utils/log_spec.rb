require 'spec_helper'
require 'howitzer/utils/log'
include Howitzer::LoggerHelper

RSpec.describe Howitzer::Utils::Log do
  context '#log' do
    subject { log }
    let(:other_log) { described_class.instance }
    it { is_expected.to be_a_kind_of(described_class) }
    it { is_expected.to equal(other_log) }
  end

  context '.error' do
    context 'when one argument given' do
      subject { log.error(*args) }
      context 'when exception given as argument' do
        let(:args) { [StandardError.new('Exception_error_message')] }
        it { expect { subject }.to raise_error(StandardError, 'Exception_error_message') }
      end
      context 'when message given as argument' do
        let(:args) { ['Runtime_error_message'] }
        it { expect { subject }.to raise_error(RuntimeError, 'Runtime_error_message') }
      end
      context 'when error object given as arg ' do
        let(:error_object) { ErrorObject = StandardError.new }
        let(:args) { error_object }
        it { expect { subject }.to raise_error(StandardError) }
      end
      context 'when number given as arg' do
        let(:args) { 123 }
        it { expect { subject }.to raise_error(RuntimeError) }
      end
    end
    context 'when two arguments given' do
      subject { log.error(*args) }
      context 'when given text as first arg and caller as second' do
        let(:args) { %w(Some_text two_args_caller) }
        it { expect { subject }.to raise_error(RuntimeError) }
      end
      context 'when given class inherited from Exception as first arg and message as second' do
        let(:error_class) { SomeError = Class.new(Exception) }
        let(:args) { [error_class, 'some text'] }
        it { expect { subject }.to raise_error(error_class, 'some text') }
      end
      context 'when given some class as first arg and (message) as second' do
        let(:some_class) { SomeClass = Class.new }
        let(:args) { [some_class, 'some text'] }
        it { expect { subject }.to raise_error(RuntimeError) }
      end
      context 'when number given as first arg and message as second' do
        let(:args) { [123, 'some text'] }
        it { expect { subject }.to raise_error(RuntimeError) }
      end
      context 'when nubmers given as args' do
        let(:args) { [123, 123] }
        it { expect { subject }.to raise_error(TypeError) }
      end
    end
    context 'when three arguments given' do
      subject { log.error(*args) }
      context 'when NameError given as first arg, message as second and caller as third' do
        let(:args) { [NameError, 'Name_error_text', 'three_args_caller'] }
        it { expect { subject }.to raise_error(NameError) }
      end
    end
  end
end
