require 'spec_helper'
require 'howitzer/web/section'
require 'howitzer/web/anonymous_section'
require 'howitzer/web/section_dsl'

RSpec.describe Howitzer::Web::SectionDsl do
  let(:section_class) do
    Class.new(Howitzer::Web::Section) do
      me :xpath, './/div'
    end
  end
  let(:web_page_class) do
    Class.new do
      include Howitzer::Web::SectionDsl
    end
  end
  before { stub_const('FooSection', section_class) }
  describe '.section' do
    subject do
      web_page_class.class_eval do
        section :foo
      end
      web_page_class
    end

    it 'should create public :foo_section instance method' do
      expect(subject.new.public_methods(false)).to include(:foo_section)
    end
    it 'should create public :foo_sections instance method' do
      expect(subject.new.public_methods(false)).to include(:foo_sections)
    end
    it 'should create public :has_foo_section? instance method' do
      expect(subject.new.public_methods(false)).to include(:has_foo_section?)
    end
    it 'should create public :has_no_foo_section? instance method' do
      expect(subject.new.public_methods(false)).to include(:has_no_foo_section?)
    end
    it 'should be protected class method' do
      expect { subject.section :bar }.to raise_error(NoMethodError)
      expect(subject.protected_methods(true)).to include(:section)
    end
  end

  describe 'dynamic_methods' do
    let(:session) { double(:session) }
    before do
      allow(Capybara).to receive(:current_session) { session }
    end
    context 'when section with single argument without block' do
      let(:finder_args) { [:xpath, './/div'] }
      let(:section_name) { :foo }
      before do
        web_page_class.class_eval do
          section :foo
        end
      end
      include_examples :dynamic_section_methods
    end

    context 'when section with single argument and block' do
      subject do
        web_page_class.class_eval do
          section :unknown do
            element :some, :id, 'do_do'
          end
        end
      end
      it 'should generate error' do
        expect { subject }.to raise_error(ArgumentError, 'Missing finder arguments')
      end
    end

    context 'when section with 2 arguments without block' do
      let(:finder_args) { ['.some_class'] }
      let(:section_name) { :foo }
      before do
        web_page_class.class_eval do
          section :foo, '.some_class'
        end
      end
      include_examples :dynamic_section_methods
    end

    context 'when section with 2 arguments and block' do
      let(:finder_args) { [:xpath, './/div'] }
      let(:section_name) { :unknown }
      let(:section_class) { Howitzer::Web::AnonymousSection }
      before do
        web_page_class.class_eval do
          section :unknown, :xpath, './/div' do
            element :some, :id, 'do_do'
          end
        end
      end
      include_examples :dynamic_section_methods
    end
  end
end
