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
        element :foo, :xpath,
                ->(title, name) { "//a[.='#{title}']/*[@name='#{name}']" }, text: 'original', 'match' => :first
        element :complex_foo, :xpath,
                ->(name, text:) { "//a[.='#{text}']/*[@name='#{name}']" }, text: 'original', match: :first
        element :bar, '.someclass', text: 'origin', match: :first
        element :top_panel, '.top', text: 'origin', match: :first
        element :baz_link, :link, ->(title:) { title }
      end
    end

    describe '#name_element' do
      context 'when simple selector' do
        subject { klass_object.send(:bar_element, 'text' => 'new', wait: 10) }
        after { subject }
        it do
          expect(klass_object.capybara_context).to receive(:find)
            .with('.someclass', wait: 10, text: 'new', match: :first)
        end
      end
      context 'when lambda selector' do
        after { subject }
        context 'with old format of lambda arguments' do
          subject { klass_object.send(:foo_element, 'Hello', 'super', 'text' => 'new', wait: 10) }
          it do
            expect_any_instance_of(Object).to receive(:puts).with(
              "WARNING! Passing lambda arguments with element options is deprecated.\n" \
              "Please use 'lambda_args' method, for example: foo_element(lambda_args(title: 'Example'), wait: 10)"
            )
            expect(klass_object.capybara_context).to receive(:find)
              .with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10, text: 'new', match: :first)
          end
        end
        context 'with single lambda keyword argument' do
          subject do
            klass_object.instance_eval do
              baz_link_element(lambda_args(title: 'MyLink'))
            end
          end
          it { expect(klass_object.capybara_context).to receive(:find).with(:link, 'MyLink') }
        end
        context 'with new format of lambda arguments' do
          subject do
            klass_object.instance_eval do
              complex_foo_element(lambda_args('complex', text: 'Hello'), 'text' => 'new', wait: 10)
            end
          end
          it do
            expect(klass_object.capybara_context).to receive(:find)
              .with(:xpath, "//a[.='Hello']/*[@name='complex']", wait: 10, text: 'new', match: :first)
          end
        end
        context 'when several execution with different data' do
          subject { nil }
          it 'does not cache previous data' do
            expect(klass_object.capybara_context).to receive(:find)
              .with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10, text: 'new', match: :first).at_least(:once)
            klass_object.instance_eval do
              foo_element(lambda_args('Hello', 'super'), 'text' => 'new', wait: 10)
            end

            expect(klass_object.capybara_context).to receive(:find)
              .with(:xpath, "//a[.='Bye']/*[@name='puper']", wait: 15, text: 'new', match: :first).at_least(:once)
            klass_object.instance_eval do
              foo_element(lambda_args('Bye', 'puper'), 'text' => 'new', wait: 15)
            end
          end
        end
      end
    end
    describe '#name_elements' do
      after { subject }
      context 'when simple selector' do
        subject { klass_object.send(:bar_elements, 'text' => 'new', wait: 10) }
        it do
          expect(klass_object.capybara_context).to receive(:all)
            .with('.someclass', wait: 10, text: 'new', match: :first)
        end
      end
      context 'when lambda selector' do
        subject do
          klass_object.instance_eval do
            foo_elements(lambda_args('Hello', 'super'), 'text' => 'new', wait: 10)
          end
        end
        it do
          expect(
            klass_object.capybara_context
          ).to receive(:all).with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10, text: 'new', match: :first)
        end
      end
    end
    describe '#wait_for_name_element' do
      context 'when simple selector' do
        subject { klass_object.send(:wait_for_bar_element, 'text' => 'new', wait: 10) }
        it do
          expect(klass_object.capybara_context).to receive(:find)
            .with('.someclass', wait: 10, text: 'new', match: :first)
          is_expected.to eq(nil)
        end
      end
      context 'when lambda selector' do
        subject do
          klass_object.instance_eval do
            wait_for_foo_element(lambda_args('Hello', 'super'), 'text' => 'new', wait: 10)
          end
        end
        it do
          expect(
            klass_object.capybara_context
          ).to receive(:find).with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10, text: 'new', match: :first)
          is_expected.to eq(nil)
        end
      end
    end
    describe '#within_name_element' do
      let(:within_scope) { double }
      after { subject }
      context 'not nested' do
        context 'when simple selector' do
          subject do
            klass_object.instance_eval do
              within_bar_element(wait: 5, text: 'new') do
                foo_element(lambda_args('Hello', 'super'), wait: 10, 'text' => 'new')
              end
            end
          end
          it do
            expect(klass_object.capybara_context).to receive(:find)
              .with('.someclass', wait: 5, text: 'new', match: :first) { within_scope }
            expect(within_scope).to receive(:find)
              .with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10, text: 'new', match: :first)
          end
        end
        context 'when lambda selector' do
          subject do
            klass_object.instance_eval do
              within_foo_element(lambda_args('Hello', 'super'), wait: 10, 'text' => 'new') do
                bar_element(wait: 10, text: 'new')
              end
            end
          end
          it do
            expect(klass_object.capybara_context).to receive(:find)
              .with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10, text: 'new', match: :first) { within_scope }
            expect(within_scope).to receive(:find).with('.someclass', wait: 10, text: 'new', match: :first)
          end
        end
      end
      context 'nested' do
        let(:nested_within_scope) { double }
        subject do
          klass_object.instance_eval do
            within_top_panel_element(wait: 10, text: 'new') do
              within_bar_element(wait: 10, text: 'new') do
                foo_element(lambda_args('Hello', 'super'), wait: 10, 'text' => 'new')
              end
            end
          end
        end
        it do
          expect(klass_object.capybara_context).to receive(:find)
            .with('.top', wait: 10, text: 'new', match: :first) { within_scope }
          expect(within_scope).to receive(:find)
            .with('.someclass', wait: 10, text: 'new', match: :first) { nested_within_scope }
          expect(nested_within_scope).to receive(:find)
            .with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10, text: 'new', match: :first)
        end
      end
    end
    describe '#has_name_element?' do
      after { subject }
      context 'when simple selector' do
        subject { klass_object.send(:has_bar_element?, wait: 10, 'text' => 'new') }
        it do
          expect(klass_object.capybara_context).to receive(:has_selector?)
            .with('.someclass', wait: 10, text: 'new', match: :first)
        end
      end
      context 'when lambda selector' do
        subject do
          klass_object.instance_eval do
            has_foo_element?(lambda_args('Hello', 'super'), wait: 10, 'text' => 'new')
          end
        end
        it do
          expect(klass_object.capybara_context).to receive(:has_selector?)
            .with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10, text: 'new', match: :first)
        end
      end
    end
    describe '#has_no_name_element?' do
      after { subject }
      context 'when simple selector' do
        subject { klass_object.send(:has_no_bar_element?, wait: 10, 'text' => 'new') }
        it do
          expect(klass_object.capybara_context).to receive(:has_no_selector?)
            .with('.someclass', wait: 10, text: 'new', match: :first)
        end
      end
      context 'when lambda selector' do
        subject do
          klass_object.instance_eval do
            has_no_foo_element?(lambda_args('Hello', 'super'), wait: 10, 'text' => 'new', match: :first)
          end
        end
        it do
          expect(klass_object.capybara_context).to receive(:has_no_selector?)
            .with(:xpath, "//a[.='Hello']/*[@name='super']", wait: 10, text: 'new', match: :first)
        end
      end
    end
  end
end
