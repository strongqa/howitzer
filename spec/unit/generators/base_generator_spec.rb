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
    let(:options) { { r: true, rspec: true } }
    subject { described_class.new(options) }
    before do
      expect_any_instance_of(described_class).to receive(:print_banner).with(no_args).once
      allow_any_instance_of(described_class).to receive(:manifest) do
        {
          files: list1,
          templates: list2,
          unknown: nil
        }
      end
    end
    it do
      expect_any_instance_of(described_class).to receive(:copy_files).with(list1).once
      expect_any_instance_of(described_class).to receive(:copy_templates).with(list2).once
      expect(subject.instance_variable_get(:@options)).to eql options
    end
  end

  describe '#manifest' do
    subject { described_class.new({}).manifest }
    before { allow_any_instance_of(described_class).to receive(:print_banner) { nil } }
    it { is_expected.to eq([]) }
  end

  describe '#banner' do
    subject { described_class.new({}).send(:banner) }
    before { allow_any_instance_of(described_class).to receive(:print_banner) { nil } }
    it { is_expected.to be_nil }
  end

  describe '#logger' do
    subject { described_class.new({}).send(:logger) }
    before { allow_any_instance_of(described_class).to receive(:print_banner) { nil } }
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

  describe '#destination' do
    subject { described_class.new({}).send(:destination) }
    before do
      allow_any_instance_of(described_class).to receive(:print_banner) { nil }
      allow(described_class).to receive(:destination) { '/' }
    end
    it { is_expected.to eq('/') }
  end

  describe '#copy_files' do
    let(:list) { [{ source: 'example.txt' }] }
    let(:source_path) { '/example_path/example.txt' }
    let(:generator) { described_class.new({}) }
    subject { generator.send(:copy_files, list) }
    before do
      allow_any_instance_of(described_class).to receive(:print_banner) { nil }
      allow(generator).to receive(:source_path).with(list.first[:source]) { source_path }
    end
    after { subject }
    context 'when source_file exists' do
      before { allow(File).to receive(:exist?).with(source_path) { true } }
      it { expect(generator).to receive(:copy_with_path).with(list.first).once }
    end
    context 'when source_file missing' do
      before { allow(File).to receive(:exist?).with(source_path) { false } }
      it { expect(generator).to receive(:puts_error).with("File '/example_path/example.txt' was not found.").once }
    end
  end

  describe '#copy_templates' do
    let(:list) { [{ source: 'example.txt.erb', destination: 'example.txt' }] }
    let(:source_path) { '/example_path/example.txt.erb' }
    let(:destination_path) { '/example_path/example.txt' }
    let(:generator) { described_class.new('rspec' => true) }
    subject { generator.send(:copy_templates, list) }
    before do
      allow_any_instance_of(described_class).to receive(:print_banner) { nil }
      allow(generator).to receive(:source_path).with(list.first[:source]) { source_path }
      allow(generator).to receive(:dest_path).with(list.first[:destination]) { destination_path }
      allow(generator).to receive(:write_template).with(destination_path, source_path)
      allow(generator).to receive(:gets) { 'h' }
    end
    after { subject }
    context 'when destination file exists' do
      before { allow(File).to receive(:exist?).with(destination_path) { true } }
      it { expect(generator).to receive(:puts_info).with("Conflict with '#{list.first[:destination]}' template").once }
      it do
        expect(generator).to receive(:print_info).with(
          "  Overwrite '#{list.first[:destination]}' template? [Yn]:"
        ).once
      end
      context 'and answer is yes' do
        before { allow(generator).to receive(:gets) { 'y' } }
        it { expect(generator).to receive(:write_template).with(destination_path, source_path).once }
        it { expect(generator).to receive(:puts_info).twice }
      end
      context 'and answer is no' do
        before { allow(generator).to receive(:gets) { 'n' } }
        it { expect(generator).to receive(:puts_info).twice }
      end
    end
    context 'when source file exists' do
      before { allow(File).to receive(:exist?).with(destination_path) { false } }
      it { expect(generator).to receive(:write_template).with(destination_path, source_path).once }
    end
  end

  describe '#print_banner' do
    let(:generator) { described_class.new({}) }
    subject { generator.send(:print_banner) }
    before do
      allow_any_instance_of(described_class).to receive(:banner) { banner }
    end
    after { subject }
    context 'when banner present' do
      let(:banner) { 'banner' }
      it { expect(described_class.logger).to receive(:puts).with(banner).twice }
    end
    context 'when banner blank' do
      let(:banner) { '' }
      it { expect(described_class.logger).not_to receive(:puts) }
    end
  end

  describe '#print_info' do
    subject { described_class.new({}).send(:print_info, 'data') }
    before { allow_any_instance_of(described_class).to receive(:print_banner) { nil } }
    after { subject }
    it { expect(described_class.logger).to receive(:print).with('      data') }
  end

  describe '#puts_info' do
    subject { described_class.new({}).send(:puts_info, 'data') }
    before { allow_any_instance_of(described_class).to receive(:print_banner) { nil } }
    after { subject }
    it { expect(described_class.logger).to receive(:puts).with('      data') }
  end

  describe '#puts_error' do
    subject { described_class.new({}).send(:puts_error, 'data') }
    before { allow_any_instance_of(described_class).to receive(:print_banner) { nil } }
    after { subject }
    it { expect(described_class.logger).to receive(:puts).with('      ERROR: data') }
  end

  describe '#source_path' do
    subject { described_class.new({}).send(:source_path, 'example.txt') }
    before do
      allow_any_instance_of(described_class).to receive(:print_banner) { nil }
    end
    it { is_expected.to include('/base/templates/example.txt') }
  end

  describe '#dest_path' do
    subject { described_class.new({}).send(:dest_path, 'example.txt') }
    before { allow_any_instance_of(described_class).to receive(:print_banner) { nil } }
    it { is_expected.to include('/example.txt') }
  end

  describe '#copy_with_path' do
    let(:generator) { described_class.new({}) }
    let(:data) { { source: 's.txt', destination: 'd.txt' } }
    let(:src) { '/path/to/s.txt' }
    let(:dst) { '/path/to/d.txt' }
    subject { generator.send(:copy_with_path, data) }
    before do
      allow_any_instance_of(described_class).to receive(:print_banner) { nil }
      allow(generator).to receive(:source_path).with('s.txt') { src }
      allow(generator).to receive(:dest_path).with('d.txt') { dst }
      allow(FileUtils).to receive(:mkdir_p).with('/path/to') { true }
    end
    after { subject }
    context 'when destination file present' do
      before { allow(File).to receive(:exist?).with(dst) { true } }
      context 'when identical with source file' do
        before { allow(FileUtils).to receive(:identical?).with(src, dst) { true } }
        it { expect(generator).to receive(:puts_info).with("Identical 'd.txt' file").once }
      end
      context 'when not identical with source file' do
        before do
          allow(FileUtils).to receive(:identical?).with(src, dst) { false }
          expect(generator).to receive(:puts_info).with("Conflict with 'd.txt' file")
          expect(generator).to receive(:print_info).with("  Overwrite 'd.txt' file? [Yn]:")
        end
        context 'when user typed Y' do
          before { allow(generator).to receive(:gets) { 'Y' } }
          it do
            expect(FileUtils).to receive(:cp).with(src, dst) { nil }.once
            expect(generator).to receive(:puts_info).with("    Forced 'd.txt' file")
          end
        end
        context 'when user typed y' do
          before { allow(generator).to receive(:gets) { 'y' } }
          it do
            expect(FileUtils).to receive(:cp).with(src, dst) { nil }.once
            expect(generator).to receive(:puts_info).with("    Forced 'd.txt' file")
          end
        end
        context 'when user typed N' do
          before { allow(generator).to receive(:gets) { 'N' } }
          it do
            expect(generator).to receive(:puts_info).with("    Skipped 'd.txt' file")
            expect(FileUtils).not_to receive(:cp)
          end
        end
        context 'when user typed n' do
          before { allow(generator).to receive(:gets) { 'n' } }
          it do
            expect(generator).to receive(:puts_info).with("    Skipped 'd.txt' file")
            expect(FileUtils).not_to receive(:cp)
          end
        end
        context 'when user typed hello' do
          before { allow(generator).to receive(:gets) { 'hello' } }
          it do
            expect(generator).not_to receive(:puts_info)
            expect(FileUtils).not_to receive(:cp)
          end
        end
      end
    end
    context 'when destination file missing' do
      before { allow(File).to receive(:exist?).with(dst) { false } }
      it do
        expect(generator).to receive(:puts_info).with("Added 'd.txt' file")
        expect(FileUtils).to receive(:cp).with(src, dst).once
      end
    end
    context 'when exception happened' do
      before { allow(FileUtils).to receive(:mkdir_p).and_raise(StandardError.new('Some error')) }
      it { expect(generator).to receive(:puts_error).with("Impossible to create 'd.txt' file. Reason: Some error") }
    end
  end
end
