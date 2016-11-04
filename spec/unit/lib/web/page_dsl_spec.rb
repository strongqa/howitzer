require 'spec_helper'
require 'howitzer/web/page_dsl'

RSpec.describe Howitzer::Web::PageDsl do
  let(:page) { Class.new { include Howitzer::Web::PageDsl } }

  describe '.on' do
    subject { page.on { 1 } }
    before { expect(Howitzer::Web::PageDsl::PageScope).to receive(:new).with(page) }
    it { is_expected.to be_nil }
  end
end

RSpec.describe Howitzer::Web::PageDsl::PageScope do
  let(:fake_page) { double }
  let(:page) { Class.new }
  before { allow(page).to receive(:given) { fake_page } }

  describe '.new' do
    subject { described_class.new(page) { bar } }
    before { expect_any_instance_of(described_class).to receive(:bar).with(no_args) { true } }
    it { is_expected.to be_a(described_class) }
  end

  describe '#is_expected' do
    let(:scope) { described_class.new(page) { 1 } }
    subject { scope.is_expected }
    before { expect(scope).to receive(:expect).with(fake_page) { true } }
    it { is_expected.to eq(true) }
  end

  describe '#method_missing' do
    context 'when starts with be_' do
      let(:scope) { described_class.new(page) { 1 } }
      subject { scope.be_a(described_class) }
      it { expect(subject.class).to eq(RSpec::Matchers::BuiltIn::BeAKindOf) }
    end

    context 'when starts with have_' do
      let(:scope) { described_class.new(page) { 1 } }
      subject { scope.have_content(described_class) }
      it { expect(subject.class).to eq(RSpec::Matchers::BuiltIn::Has) }
    end

    context 'when outer_var' do
      let(:outer_context) do
        Class.new do
          def initialize(klass)
            @klass = klass
            @a = 5
          end

          def scope
            @klass.new(nil) { 1 }
          end
        end
      end
      let(:scope) { outer_context.new(described_class).scope }
      subject { scope.outer_var(:@a) }
      it { is_expected.to eq(5) }
    end

    context 'when outer_var' do
      let(:outer_context) do
        Class.new do
          def initialize(klass)
            @klass = klass
            @a = 5
          end

          def secret
            '***'
          end

          def scope
            @klass.new(nil) { 1 }
          end
        end
      end
      let(:scope) { outer_context.new(described_class).scope }
      subject { scope.outer_meth(:secret) }
      it { is_expected.to eq('***') }
    end

    context 'when starts other prefix' do
      let(:scope) { described_class.new(page) { 1 } }
      subject { scope.foo(1, 2, 3) }
      before { expect(fake_page).to receive(:foo).with(1, 2, 3) { true } }
      it { is_expected.to eq(true) }
    end
  end
end
