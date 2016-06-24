require 'spec_helper'
require 'howitzer/web/element'

RSpec.describe Howitzer::Web::Element do
  let(:web_page_class) do
    Class.new do
      include Howitzer::Web::Element
    end
  end
  describe '.element' do
    context 'when regular capybara params' do
      subject do
        web_page_class.class_eval do
          element :foo, :xpath, '//a'
        end
        web_page_class
      end
      it 'should create private :foo_element instance method' do
        expect(subject.new.private_methods(false)).to include(:foo_element)
      end
      it 'should create private :foo_elements instance method' do
        expect(subject.new.private_methods(false)).to include(:foo_elements)
      end
      it 'should create public :has_foo_element? instance method' do
        expect(subject.new.public_methods(false)).to include(:has_foo_element?)
      end
      it 'should create public :has_no_foo_element? instance method' do
        expect(subject.new.public_methods(false)).to include(:has_no_foo_element?)
      end
      it 'should be protected class method' do
        expect { subject.element :bar }.to raise_error(NoMethodError)
        expect(subject.protected_methods(true)).to include(:element)
      end
    end
    context 'when 1 param is proc' do
      subject do
        web_page_class.class_eval do
          element :foo, :xpath, ->(title) { "//a[.='#{title}']" }
        end
        web_page_class
      end
      it 'should create private :foo_element instance method' do
        expect(subject.new.private_methods(false)).to include(:foo_element)
      end
      it 'should create private :foo_elements instance method' do
        expect(subject.new.private_methods(false)).to include(:foo_elements)
      end
      it 'should create public :has_foo_element? instance method' do
        expect(subject.new.public_methods(false)).to include(:has_foo_element?)
      end
      it 'should create public :has_no_foo_element? instance method' do
        expect(subject.new.public_methods(false)).to include(:has_no_foo_element?)
      end
      it 'should be protected class method' do
        expect { subject.element :bar }.to raise_error(NoMethodError)
        expect(subject.protected_methods(true)).to include(:element)
      end
    end
    context 'when 2 params are proc' do
      subject do
        web_page_class.class_eval do
          element :foo, -> { puts 1 }, ->(title) { "//a[.='#{title}']" }
        end
        web_page_class
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
    let(:session) { double(:session) }
    before do
      allow(Capybara).to receive(:current_session) { session }
      web_page_class.class_eval do
        element :foo, :xpath, ->(title) { "//a[.='#{title}']" }
        element :bar, '.someclass'
      end
    end
    after { subject }

    describe '#name_element' do
      context 'when simple selector' do
        subject { web_page_object.send(:bar_element) }
        it { expect(session).to receive(:find).with('.someclass') }
      end
      context 'when lambda selector' do
        subject { web_page_object.send(:foo_element, 'Hello') }
        it { expect(session).to receive(:find).with(:xpath, "//a[.='Hello']") }
      end
    end
    describe '#name_elements' do
      context 'when simple selector' do
        subject { web_page_object.send(:bar_elements) }
        it { expect(session).to receive(:all).with('.someclass') }
      end
      context 'when lambda selector' do
        subject { web_page_object.send(:foo_elements, 'Hello') }
        it { expect(session).to receive(:all).with(:xpath, "//a[.='Hello']") }
      end
    end
    describe '#has_name_element?' do
      context 'when simple selector' do
        subject { web_page_object.send(:has_bar_element?) }
        it { expect(session).to receive(:has_selector?).with('.someclass') }
      end
      context 'when lambda selector' do
        subject { web_page_object.send(:has_foo_element?, 'Hello') }
        it { expect(session).to receive(:has_selector?).with(:xpath, "//a[.='Hello']") }
      end
    end
    describe '#has_no_name_element?' do
      context 'when simple selector' do
        subject { web_page_object.send(:has_no_bar_element?) }
        it { expect(session).to receive(:has_no_selector?).with('.someclass') }
      end
      context 'when lambda selector' do
        subject { web_page_object.send(:has_no_foo_element?, 'Hello') }
        it { expect(session).to receive(:has_no_selector?).with(:xpath, "//a[.='Hello']") }
      end
    end
  end
end
