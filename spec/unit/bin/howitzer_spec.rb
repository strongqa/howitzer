require "spec_helper"
load "bin/howitzer"

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
        expect(self).to receive(:puts).with(%{
howitzer [command {--cucumber, --rspec}] | {options}

Commands are ...
    install                  Generate test framework units:
          --rspec                add RSpec integration with framework
          --cucumber             add Cucumber integration with framework
Options are ...
    --help                   Display this help message.
    --version                Display the program version.
  })
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
end