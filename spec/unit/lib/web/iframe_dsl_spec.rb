require 'spec_helper'
require 'howitzer/web/page'

RSpec.describe Howitzer::Web::IframeDsl do
  let(:fb_page_class) do
    Class.new(Howitzer::Web::Page) do
      section :navbar, :xpath, './body' do
        element :like_button, '#foo_id'
      end
    end
  end

  let(:web_page_class) do
    Class.new(Howitzer::Web::Page)
  end

  before do
    allow_any_instance_of(fb_page_class).to receive(:check_validations_are_defined!)
    allow_any_instance_of(web_page_class).to receive(:check_validations_are_defined!)
    stub_const('FbPage', fb_page_class)
  end

  describe '.iframe' do
    context 'when selector is integer' do
      subject do
        web_page_class.class_eval do
          iframe :fb, 1
        end
        web_page_class
      end

      it 'should create public :fb_iframe instance method' do
        expect(subject.instance.public_methods(false)).to include(:fb_iframe)
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

  include_examples :capybara_context_holder

  describe 'dynamic_methods' do
    let(:web_page_object) { web_page_class.instance }
    let(:kontext) { double(:kontext) }
    before do
      allow(Capybara).to receive(:current_session) { kontext }
    end
    after { subject }

    describe '#name_iframe' do
      let(:block) { proc {} }
      subject { web_page_object.send(:fb_iframe, &block) }
      context 'when integer selector' do
        before { web_page_class.class_eval { iframe :fb, 1 } }
        it do
          expect(kontext).to receive(:within_frame).with(1) { |&block| block.call }
          expect(block).to receive(:call).with(fb_page_class.instance)
        end
      end
      context 'when string selector' do
        before { web_page_class.class_eval { iframe :fb, 'loko' } }
        it do
          expect(kontext).to receive(:within_frame).with('loko') { |&block| block.call }
          expect(block).to receive(:call).with(fb_page_class.instance)
        end
      end
    end
    describe '#has_name_iframe?' do
      subject { web_page_object.has_fb_iframe? }
      context 'when integer selector' do
        before { web_page_class.class_eval { iframe :fb, 1 } }
        it { expect(kontext).to receive(:has_selector?).with('iframe:nth-of-type(2)') }
      end
      context 'when string selector' do
        before { web_page_class.class_eval { iframe :fb, 'loko' } }
        it { expect(kontext).to receive(:has_selector?).with(:frame, 'loko') }
      end
    end
    describe '#has_no_name_iframe?' do
      subject { web_page_object.has_no_fb_iframe? }
      context 'when integer selector' do
        before { web_page_class.class_eval { iframe :fb, 1 } }
        it { expect(kontext).to receive(:has_no_selector?).with('iframe:nth-of-type(2)') }
      end
      context 'when string selector' do
        before { web_page_class.class_eval { iframe :fb, 'loko' } }
        it { expect(kontext).to receive(:has_no_selector?).with(:frame, 'loko') }
      end
    end
  end
end
