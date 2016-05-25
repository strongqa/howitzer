require 'spec_helper'
require 'howitzer/web_page_element'

RSpec.describe 'Howitzer::WebPageElement' do
  let(:web_page_class) do
    Class.new do
      include Howitzer::WebPageElement
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
      it 'should be private class method' do
        expect { subject.element :bar }.to raise_error(NoMethodError)
        expect(subject.private_methods(true)).to include(:element)
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
      it 'should be private class method' do
        expect { subject.element :bar }.to raise_error(NoMethodError)
        expect(subject.private_methods(true)).to include(:element)
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
end
