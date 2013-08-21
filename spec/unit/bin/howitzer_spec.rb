require "spec_helper"
load "bin/howitzer"

HELP_MESSAGE = %{
howitzer [command {--cucumber, --rspec}] | {options}

Commands are ...
    install                  Generate test framework units:
          --rspec                add RSpec integration with framework
          --cucumber             add Cucumber integration with framework
Options are ...
    --help                   Display this help message.
    --version                Display the program version.
  }

shared_examples "check argument" do |arg|
  before do
    stub_const("ARGV", [arg])
    expect(self).to_not receive(:puts)
    expect(self).to_not receive(:exit)
  end
  context "(#{arg})" do
    let(:arg) { arg }
    it { expect(subject).to be_nil }
  end
end

describe Howitzer do
  describe "#check_arguments" do
    subject { check_arguments }
    context "when right arguments specified" do
      it_behaves_like "check argument", 'install --cucumber'
      it_behaves_like "check argument", 'install --rspec'
      it_behaves_like "check argument", 'install --cucumber --rspec'
      it_behaves_like "check argument", 'install --rspec --cucumber'
      it_behaves_like "check argument", '--version'
      it_behaves_like "check argument", '--help'
      it_behaves_like "check argument", '--HELP'
    end
    context "when arguments incorrect" do
      before do
        expect(self).to receive(:puts).with("ERROR: incorrect options. Please, see help for details").once
        expect(self).to receive(:puts).with(HELP_MESSAGE)
        expect(self).to receive(:exit).with(1)
      end
      context "(missing arguments)" do
        it { expect(subject).to be_nil  }
      end
      context "UNKNOWN argument" do
        let(:arg) { '--unknown' }
        before { stub_const("ARGV", [arg]) }
        it { expect(subject).to be_nil }
      end
    end
  end

  describe "#parse_options" do
    subject { parse_options }
    context "when correct argument received" do
      before do
        stub_const("ARGV", arg)
        expect(self).not_to receive(:puts).with("ERROR: incorrect first argument '#{arg}'")
      end
      context "'--version' argument given" do
        let(:arg) { ['--version'] }
      before{ stub_const("Howitzer::VERSION", '1.0.0') }
        it do
          expect(self).to receive(:exit).with(0).once
          expect(self).to receive(:puts).with("Version: 1.0.0")
          subject
        end
      end
      context "'--help' argument given" do
        let(:arg) { ['--help'] }
        it do
          expect(self).to receive(:puts).with(HELP_MESSAGE)
          subject
        end
      end
      context "'install' argument" do
        let(:primary_arg) { 'install' }
        let(:generator) { double('generator') }
        before do
          expect(generator).to receive(:run).with(['config']).once
          expect(generator).to receive(:run).with(['pages']).once
          expect(generator).to receive(:run).with(['tasks']).once
          expect(generator).to receive(:run).with(['emails']).once
          expect(generator).to receive(:run).with(['root']).once
          expect(RubiGen::Scripts::Generate).to receive(:new).exactly(5).times.and_return(generator)
          expect(self).not_to receive(:puts).with("ERROR: Empty option specified.")
          expect(self).not_to receive(:puts).with("ERROR: Unknown option specified.")
          expect(self).not_to receive(:puts).with(HELP_MESSAGE)
        end
        context "with option '--cucumber'" do
          let(:arg) { [primary_arg, '--cucumber'] }
          before { expect(RubiGen::Scripts::Generate).to receive(:new).and_return(generator) }
          it do
            expect(generator).to receive(:run).with(['cucumber'])
            subject
           end
        end
        context "with option '--rspec'" do
          let(:arg) {[primary_arg, '--rspec']}
          before { expect(RubiGen::Scripts::Generate).to receive(:new).exactly(1).times.and_return(generator)}
          it do
            expect(generator).to receive(:run).with(['rspec']).once
            subject
          end
        end
      end
    end
    context "when incorrect arguments received" do
      before { stub_const("ARGV", arg) }
      context "with (missing) argument" do
        let(:arg) {[]}
        it do
          expect(self).to receive(:puts).with("ERROR: incorrect first argument ('')")
          expect(self).to receive(:puts).with(HELP_MESSAGE)
          expect(self).to receive(:exit).with(1)
          subject
        end
      end
      context "with UNKNOWN argument" do
        let(:arg) {['unknown']}
        it do
          expect(self).to receive(:puts).with("ERROR: incorrect first argument ('unknown')")
          expect(self).to receive(:puts).with(HELP_MESSAGE)
          expect(self).to receive(:exit).with(1)
          subject
        end
      end
    end

    context "when 'install' option received with incorrect arguments" do
      let(:primary_arg) { 'install' }
      let(:generator) { double('generator') }
      before { stub_const("ARGV", arg) }
      context "with UNKNOWN option specified" do
        let(:arg) {[primary_arg, '--unknown']}
        it do
          expect(RubiGen::Scripts::Generate).not_to receive(:new)
          expect(self).to receive(:puts).with("ERROR: Unknown '--unknown' option specified.")
          expect(self).to receive(:puts).with(HELP_MESSAGE)
          expect(self).to receive(:exit).with(0)
          subject
        end
      end
      context "with no option specified" do
        let(:arg) {[primary_arg]}
        it do
          expect(RubiGen::Scripts::Generate).not_to receive(:new)
          expect(self).to receive(:puts).with("ERROR: No option specified for install command.")
          expect(self).to receive(:puts).with(HELP_MESSAGE)
          expect(self).to receive(:exit).with(0)
          subject
        end
      end
    end
  end
end