require 'spec_helper'
require 'howitzer/web/page'

RSpec.describe 'Iframe dsl for test class' do
  let(:fb_page_class) do
    Class.new(Howitzer::Web::Page) do
      section :navbar, :xpath, './body' do
        element :like_button, '#foo_id'
      end
    end
  end
  let(:test_page_class) do
    Class.new(Howitzer::Web::Page)
  end
  before { stub_const('FbPage', fb_page_class) }
  describe '.iframe' do
    context 'when selector is integer' do
      subject do
        test_page_class.class_eval do
          iframe :fb, 1
        end
        test_page_class
      end

      it 'should create public :fb_iframe instance method' do
        expect(subject.instance.public_methods(false)).to include(:fb_section)
      end
      it 'should create public :has_fb_iframe? instance method' do
        expect(subject.instance.public_methods(false)).to include(:has_fb_iframe?)
      end
      it 'should create public :has_no_fb_iframe? instance method' do
        expect(subject.instance.public_methods(false)).to include(:has_no_fb_iframe?)
      end
      it 'should be protected class method' do
        expect { subject.iframe :bar }.to raise_error(NoMethodError)
        expect(subject.protected_methods(true)).to include(:iframe)
      end
    end
  end
end
