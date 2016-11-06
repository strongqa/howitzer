require 'spec_helper'

RSpec.shared_examples :element_dsl do
  describe '.element' do
    context 'when regular capybara params' do
      before do
        klass.class_eval do
          element :foo, :xpath, '//a'
        end
      end
      it 'should create private :foo_element instance method' do
        expect(klass_object.private_methods(false)).to include(:foo_element)
      end
      it 'should create private :foo_elements instance method' do
        expect(klass_object.private_methods(false)).to include(:foo_elements)
      end
      it 'should create private :wait_for_foo_element instance method' do
        expect(klass_object.private_methods(false)).to include(:wait_for_foo_element)
      end
      it 'should create public :has_foo_element? instance method' do
        expect(klass_object.public_methods(false)).to include(:has_foo_element?)
      end
      it 'should create public :has_no_foo_element? instance method' do
        expect(klass_object.public_methods(false)).to include(:has_no_foo_element?)
      end
      it 'should be protected class method' do
        expect { klass.element :bar }.to raise_error(NoMethodError)
        expect(klass.protected_methods(true)).to include(:element)
      end
    end
    context 'when 1 param is proc' do
      before do
        klass.class_eval do
          element :foo, :xpath, ->(title) { "//a[.='#{title}']" }
        end
      end
      it 'should create private :foo_element instance method' do
        expect(klass_object.private_methods(false)).to include(:foo_element)
      end
      it 'should create private :foo_elements instance method' do
        expect(klass_object.private_methods(false)).to include(:foo_elements)
      end
      it 'should create private :wait_for_foo_element instance method' do
        expect(klass_object.private_methods(false)).to include(:wait_for_foo_element)
      end
      it 'should create public :has_foo_element? instance method' do
        expect(klass_object.public_methods(false)).to include(:has_foo_element?)
      end
      it 'should create public :has_no_foo_element? instance method' do
        expect(klass_object.public_methods(false)).to include(:has_no_foo_element?)
      end
      it 'should be protected class method' do
        expect { klass.element :bar }.to raise_error(NoMethodError)
        expect(klass.protected_methods(true)).to include(:element)
      end
    end
    context 'when 2 params are proc' do
      subject do
        klass.class_eval do
          element :foo, -> { puts 1 }, ->(title) { "//a[.='#{title}']" }
        end
      end
      it 'should generate error' do
        expect { subject.element :bar }.to raise_error(
          Howitzer::BadElementParamsError,
          'Using more than 1 proc in arguments is forbidden'
        )
      end
    end
  end

  describe 'dynamic_methods' do
    let(:web_page_object) { web_page_class.new }
    let(:kontext) { double(:kontext) }
    before do
      allow(Capybara).to receive(:current_session) { kontext }
      klass.class_eval do
        element :foo, :xpath, ->(title, name) { "//a[.='#{title}']/*[@name='#{name}']" }
        element :bar, '.someclass'
      end
    end

    describe '#name_element' do
      after { subject }
      context 'when simple selector' do
        subject { klass_object.send(:bar_element, wait: 10) }
        it { expect(kontext).to receive(:find).with('.someclass', wait: 10) }
      end
      context 'when lambda selector' do
        subject { klass_object.send(:foo_element, 'Hello', 'super', wait: 10) }
        it { expect(kontext).to receive(:find).with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10) }
      end
    end
    describe '#name_elements' do
      after { subject }
      context 'when simple selector' do
        subject { klass_object.send(:bar_elements, wait: 10) }
        it { expect(kontext).to receive(:all).with('.someclass', wait: 10) }
      end
      context 'when lambda selector' do
        subject { klass_object.send(:foo_elements, 'Hello', 'super', wait: 10) }
        it { expect(kontext).to receive(:all).with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10) }
      end
    end
    describe '#wait_for_name_element' do
      context 'when simple selector' do
        subject { klass_object.send(:wait_for_bar_element, wait: 10) }
        it do
          expect(kontext).to receive(:find).with('.someclass', wait: 10)
          is_expected.to eq(nil)
        end
      end
      context 'when lambda selector' do
        subject { klass_object.send(:wait_for_foo_element, 'Hello', 'super', wait: 10) }
        it do
          expect(kontext).to receive(:find).with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10)
          is_expected.to eq(nil)
        end
      end
    end
    describe '#has_name_element?' do
      after { subject }
      context 'when simple selector' do
        subject { klass_object.send(:has_bar_element?, wait: 10) }
        it { expect(kontext).to receive(:has_selector?).with('.someclass', wait: 10) }
      end
      context 'when lambda selector' do
        subject { klass_object.send(:has_foo_element?, 'Hello', 'super', wait: 10) }
        it { expect(kontext).to receive(:has_selector?).with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10) }
      end
    end
    describe '#has_no_name_element?' do
      after { subject }
      context 'when simple selector' do
        subject { klass_object.send(:has_no_bar_element?, wait: 10) }
        it { expect(kontext).to receive(:has_no_selector?).with('.someclass', wait: 10) }
      end
      context 'when lambda selector' do
        subject { klass_object.send(:has_no_foo_element?, 'Hello', 'super', wait: 10) }
        it do
          expect(kontext).to receive(:has_no_selector?).with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10)
        end
      end
    end
  end
end
