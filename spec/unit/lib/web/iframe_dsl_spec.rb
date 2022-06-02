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
  let(:nested_class) do
    module Foo
      Class.new(Howitzer::Web::Page) do
        section :navbar, :xpath, './body' do
          element :like_button, '#foo_id'
        end
      end
    end
  end
  let(:double_nested_class) do
    module Foo
      module Bar
        Class.new(Howitzer::Web::Page) do
          section :navbar, :xpath, './body' do
            element :like_button, '#foo_id'
          end
        end
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
    stub_const('Foo::FbPage', nested_class)
    stub_const('Foo::Bar::FbHomePage', double_nested_class)
    allow(Howitzer::Web::Page).to receive(:descendants) { [FbPage, Foo::FbPage, Foo::Bar::FbHomePage] }
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

    context 'when selector is not specified' do
      subject do
        web_page_class.class_eval do
          iframe :fb
        end
        web_page_class
      end

      it 'should raise error' do
        expect { subject }.to raise_error(ArgumentError, 'iframe selector arguments must be specified')
      end
    end

    context 'when class defined explicity' do
      subject do
        web_page_class.class_eval do
          iframe :fb, FbPage, 1
        end
        web_page_class
      end
      it 'should find page class specified' do
        expect(subject).to eql(web_page_class)
      end
    end

    context 'when frame nested in module' do
      subject do
        web_page_class.class_eval do
          iframe :foo_fb, 1
        end
        web_page_class
      end
      it 'should find page class nested in module' do
        expect(subject).to eql(web_page_class)
      end
    end

    context 'when frame nested in module nested in module' do
      subject do
        web_page_class.class_eval do
          iframe :foo_bar_fb_home, 1
        end
        web_page_class
      end
      it 'should find class nested in modules' do
        expect(subject).to eql(web_page_class)
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
      context 'when no options' do
        subject { web_page_object.fb_iframe(&block) }
        before { web_page_class.class_eval { iframe :fb, 'foo' } }
        it do
          expect(kontext).to receive(:within_frame)
            .with('foo') { |&block| block.call }
          expect(block).to receive(:call).with(fb_page_class.instance)
          expect(fb_page_class).to receive(:displayed?).with(no_args)
        end
      end
      context 'when all possible options' do
        subject { web_page_object.fb_iframe(wait: 10, text: 'new', &block) }
        before { web_page_class.class_eval { iframe :fb, :xpath, './/foo', match: :first, text: 'origin' } }
        it do
          expect(kontext).to receive(:within_frame)
            .with(:xpath, './/foo', { match: :first, wait: 10, text: 'new' }) { |&block| block.call }
          expect(block).to receive(:call).with(fb_page_class.instance)
          expect(fb_page_class).to receive(:displayed?).with(no_args)
        end
      end
    end
    describe '#has_name_iframe?' do
      subject { web_page_object.has_fb_iframe?(wait: 1, text: 'new') }
      context 'when first argument is integer' do
        before { web_page_class.class_eval { iframe :fb, 1, match: :first, text: 'origin' } }
        it do
          expect(kontext).to receive(:has_selector?)
            .with('iframe:nth-of-type(2)', { match: :first, wait: 1, text: 'new' })
        end
      end
      context 'when first argument is string' do
        before { web_page_class.class_eval { iframe :fb, 'loko', match: :first, text: 'origin' } }
        it { expect(kontext).to receive(:has_selector?).with(:frame, 'loko', { match: :first, wait: 1, text: 'new' }) }
      end
      context 'when first argument is hash' do
        before { web_page_class.class_eval { iframe :fb, name: 'loko', match: :first, text: 'origin' } }
        it do
          expect(kontext).to receive(:has_selector?)
            .with(:frame, { name: 'loko', match: :first, wait: 1, text: 'new' })
        end
      end
      context 'when first argument is symbol' do
        before { web_page_class.class_eval { iframe :fb, :xpath, './/foo', match: :first, text: 'origin' } }
        it {
          expect(kontext).to receive(:has_selector?).with(:xpath, './/foo', { match: :first, wait: 1, text: 'new' })
        }
      end
    end
    describe '#has_no_name_iframe?' do
      subject { web_page_object.has_no_fb_iframe?(wait: 1, text: 'new') }
      context 'when first argument is integer' do
        before { web_page_class.class_eval { iframe :fb, 1, match: :first, text: 'origin' } }
        it do
          expect(kontext).to receive(:has_no_selector?)
            .with('iframe:nth-of-type(2)', { match: :first, wait: 1, text: 'new' })
        end
      end
      context 'when first argument is string' do
        before { web_page_class.class_eval { iframe :fb, 'loko', match: :first, text: 'origin' } }
        it {
          expect(kontext).to receive(:has_no_selector?).with(:frame, 'loko', { match: :first, wait: 1, text: 'new' })
        }
      end
      context 'when first argument is hash' do
        before { web_page_class.class_eval { iframe :fb, name: 'loko', match: :first, text: 'origin' } }
        it do
          expect(kontext).to receive(:has_no_selector?).with(:frame,
                                                             { name: 'loko', match: :first, wait: 1, text: 'new' })
        end
      end
      context 'when first argument is symbol' do
        before { web_page_class.class_eval { iframe :fb, :xpath, './/foo', match: :first, text: 'origin' } }
        it {
          expect(kontext).to receive(:has_no_selector?).with(:xpath, './/foo', { match: :first, wait: 1, text: 'new' })
        }
      end
    end
  end
end
