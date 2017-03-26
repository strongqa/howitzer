require 'spec_helper'
require 'howitzer/web/section'

RSpec.describe Howitzer::Web::SectionDsl do
  let(:section_class) do
    Class.new(Howitzer::Web::Section) do
      me :xpath, './/div'
    end
  end
  let(:web_page_class) do
    Class.new do
      include Howitzer::Web::SectionDsl

      def capybara_context
        Capybara.current_session
      end
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

  describe 'Dsl on section' do
    let(:other_section_class) do
      Class.new(Howitzer::Web::Section) do
        me '#id'
        element :baz, '.klass'
      end
    end
    let(:parent) { double }
    let(:capybara_context) { double }
    let(:nested_capybara_context) { double }
    let(:capybara_element) { double }
    subject { section_class.new(parent, capybara_context) }
    before do
      stub_const('BarSection', other_section_class)
      section_class.class_eval do
        section :bar
      end
      expect(capybara_context).to receive(:find).with('#id').at_least(:once) { nested_capybara_context }
      expect(nested_capybara_context).to receive(:find).with('.klass') { capybara_element }
    end
    it 'can work with nested section' do
      expect(subject.bar_section).to be_a(other_section_class)
      expect(subject.bar_section.private_methods(false)).to include(:baz_element)
      expect(subject.bar_section.send(:baz_element)).to eq(capybara_element)
    end
  end

  describe 'Dsl on page' do
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
      let(:section_class) { Howitzer::Web::BaseSection }
      before do
        web_page_class.class_eval do
          section :unknown, :xpath, './/div' do
            element :some, :id, 'do_do'
          end
        end
      end
      include_examples :dynamic_section_methods
    end

    context 'when nested section with 2 arguments and block' do
      let(:finder_args) { [:xpath, './/div'] }
      let(:section_name) { :name1 }
      let(:section_class) { Howitzer::Web::BaseSection }
      before do
        web_page_class.class_eval do
          section :name1, :xpath, './/div' do
            element :some1, :id, 'do_do'

            section :name2, '#klass' do
              element :some2, :xpath, './/a'
            end
          end
        end
      end

      include_examples :dynamic_section_methods
      include_examples :capybara_context_holder

      context 'checking nested level' do
        let(:context2) { double }
        let(:context3) { double }
        let(:capybara_element) { double }
        before do
          expect(session).to receive(:find).with(*finder_args).once.and_return(context2)
          expect(context2).to receive(:find).with('#klass').and_return(context3)
          expect(context3).to receive(:find).with(:xpath, './/a').and_return(capybara_element)
        end

        it 'can work with nested section' do
          nested_section = web_page_class.new.name1_section.name2_section
          expect(nested_section).to be_a(section_class)
          expect(nested_section.private_methods(false)).to include(:some2_element)
          expect(nested_section.send(:some2_element)).to eq(capybara_element)
        end
      end
    end
  end
end
