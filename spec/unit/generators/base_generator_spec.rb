require 'spec_helper'

RSpec.describe Howitzer::BaseGenerator do
  let(:output) { StringIO.new }
  let(:destination) { Dir.mktmpdir }

  describe '.logger' do
    subject { described_class.logger }
    before { described_class.instance_variable_set('@logger', output) }
    it { is_expected.to eq(output) }
  end

  describe '.logger=' do
    subject { described_class.instance_variable_get('@logger') }
    before { described_class.logger = output }
    it { is_expected.to eq(output) }
  end

  describe '.destination' do
    subject { described_class.destination }
    before { described_class.instance_variable_set('@destination', destination) }
    it { is_expected.to eq(destination) }
  end

  describe '.destination=' do
    subject { described_class.instance_variable_get('@destination') }
    before { described_class.destination = destination }
    it { is_expected.to eq(destination) }
  end

  describe 'constructor' do
    let(:list1) { double(:list1) }
    let(:list2) { double(:list2) }
    subject { described_class.new }
    before do
      expect_any_instance_of(described_class).to receive(:print_banner).with(no_args).once
      allow_any_instance_of(described_class).to receive(:manifest) do
        {
          files: list1,
          templates: list2
        }
      end
    end
    it do
      expect_any_instance_of(described_class).to receive(:copy_files).with(list1).once
      expect_any_instance_of(described_class).to receive(:copy_templates).with(list2).once
      subject
    end
  end

  describe '#manifest' do
    subject { described_class.new.manifest }
    before { allow_any_instance_of(described_class).to receive(:initialize) { nil } }
    it { is_expected.to be_nil }
  end

  describe '#banner' do
    subject { described_class.new.send(:banner) }
    before { allow_any_instance_of(described_class).to receive(:initialize) { nil } }
    it { is_expected.to be_nil }
  end

  describe '#logger' do
    subject { described_class.new.send(:logger) }
    before { allow_any_instance_of(described_class).to receive(:initialize) { nil } }
    context 'when not specified' do
      before { described_class.instance_variable_set('@logger', nil) }
      it { is_expected.to eq($stdout) }
    end
    context 'when custom' do
      let(:output) { StringIO.new }
      before { described_class.instance_variable_set('@logger', output) }
      it { is_expected.to eq(output) }
    end
  end

  # describe '#destination' do
  #   subject { described_class.new.send(:destination) }
  #   before { allow_any_instance_of(described_class).to receive(:initialize) { nil } }
  #   context 'when not specified' do
  #     before { described_class.instance_variable_set('@destination', nil) }
  #     it { is_expected.to eq(Dir.pwd) }
  #   end
  #   context 'when custom' do
  #     let(:destination) { '/' }
  #     before { described_class.instance_variable_set('@destination', destination) }
  #     it { is_expected.to eq(destination) }
  #   end
  # end

  describe '#copy_files' do
    let(:list) { [ {source: 'example.txt'} ] }
    let(:source_path) { '/example_path/example.txt' }
    let(:generator) { described_class.new }
    subject { generator.send(:copy_files, list) }
    before do
      allow_any_instance_of(described_class).to receive(:initialize) { nil }
      allow(generator).to receive(:source_path).with(list.first[:source]) { source_path }
    end
    after { subject }
    context 'when source_file exists' do
      before { allow(File).to receive(:exists?).with(source_path) { true } }
      it { expect(generator).to receive(:copy_with_path).with(list.first).once }
    end
    context 'when source_file missing' do
      before { allow(File).to receive(:exists?).with(source_path) { false } }
      it { expect(generator).to receive(:puts_error).with("File '/example_path/example.txt' was not found.").once }
    end
  end

  describe '#copy_templates' do
    subject { described_class.new.send(:copy_templates, nil) }
    before { allow_any_instance_of(described_class).to receive(:initialize) { nil } }
    it { is_expected.to be_nil }
  end

  describe '#print_banner' do
    let(:generator) { described_class.new }
    subject { generator.send(:print_banner) }
    before do
      allow_any_instance_of(described_class).to receive(:initialize) { nil }
      allow(generator).to receive(:banner) { banner }
    end
    after { subject }
    context 'when banner present' do
      let(:banner) { 'banner' }
      it { expect(described_class.logger).to receive(:puts).with(banner).once }
    end
    context 'when banner blank' do
      let(:banner) { '' }
      it { expect(described_class.logger).not_to receive(:puts) }
    end
  end

  describe '#print_info' do
    subject { described_class.new.send(:print_info, 'data') }
    before { allow_any_instance_of(described_class).to receive(:initialize) { nil } }
    after { subject }
    it { expect(described_class.logger).to receive(:print).with('      data')}
  end

  describe '#puts_info' do
    subject { described_class.new.send(:puts_info, 'data') }
    before { allow_any_instance_of(described_class).to receive(:initialize) { nil } }
    after { subject }
    it { expect(described_class.logger).to receive(:puts).with('      data')}
  end

  describe '#puts_error' do
    subject { described_class.new.send(:puts_error, 'data') }
    before { allow_any_instance_of(described_class).to receive(:initialize) { nil } }
    after { subject }
    it { expect(described_class.logger).to receive(:puts).with('      ERROR: data')}
  end

  describe '#source_path' do
    subject { described_class.new.send(:source_path, 'example.txt') }
    before do
      allow_any_instance_of(described_class).to receive(:initialize) { nil }
      allow(File).to receive(:dirname) { '/' }
    end
    it { is_expected.to eq('/base/templates/example.txt') }
  end

  # describe '#dest_path' do
  #   subject { described_class.new.send(:dest_path, 'example.txt') }
  #   before { allow_any_instance_of(described_class).to receive(:initialize) { nil } }
  #   it { is_expected.to eq('/example.txt') }
  # end

  describe '#copy_with_path' do
    let(:generator) { described_class.new }
    let(:data) { {source: 's.txt', destination: 'd.txt'} }
    let(:src) { '/path/to/s.txt' }
    let(:dst) { '/path/to/d.txt' }
    subject { generator.send(:copy_with_path, data) }
    before do
      allow_any_instance_of(described_class).to receive(:initialize) { nil }
      allow(generator).to receive(:source_path).with('s.txt') { src }
      allow(generator).to receive(:dest_path).with('d.txt') { dst }
      #allow(File).to receive(:dirname).with('/path/to/d.txt') { ''}
      allow(FileUtils).to receive(:mkdir_p).with('/path/to') { true }
    end
    after { subject }
    context 'when destination file present' do
      before { allow(File).to receive(:exists?).with(dst) { true } }
      context 'when identical with source file' do
        before { allow(File).to receive(:identical?).with(src, dst) { true } }
      end
      context 'when not identical with source file' do
        before { allow(File).to receive(:identical?).with(src, dst) { false } }
        # context 'when user typed Y' do
        #   allow(generator).to receive(:gets) { 'Y' }
        # end
        # context 'when user typed y' do
        #   allow(generator).to receive(:gets) { 'y' }
        # end
        # context 'when user typed N' do
        #   allow(generator).to receive(:gets) { 'N' }
        # end
        # context 'when user typed n' do
        #   allow(generator).to receive(:gets) { 'n' }
        # end
        # context 'when user typed hello' do
        #   allow(generator).to receive(:gets) { 'hello' }
        # end
      end
    end
    context 'when destination file missing' do
      before { allow(File).to receive(:exists?).with(dst) { false } }
    end
    context 'when exception happened' do

    end
  end

end