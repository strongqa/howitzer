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

    it 'should create private :foo_section instance method' do
      expect(subject.new.private_methods(false)).to include(:foo_section)
    end
    it 'should create private :foo_sections instance method' do
      expect(subject.new.private_methods(false)).to include(:foo_sections)
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

  describe 'dynamic_methods'
end
