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

  describe 'dynamic_methods' do
    context 'when section with single argument without block' do
      let(:web_page_object) { web_page_class.new }
      let(:session) { double(:session) }
      before do
        allow(Capybara).to receive(:current_session) { session }
        web_page_class.class_eval do
          section :foo
        end
      end
      describe '#name_section' do
        let(:capybara_element) { double }
        subject { web_page_object.send(:foo_section) }
        before { expect(session).to receive(:find).with(:xpath, './/div').once { capybara_element } }
        it { is_expected.to be_a(section_class) }
      end
      describe '#name_sections' do
        subject { web_page_object.send(:foo_sections) }
        let(:capybara_element1) { double }
        let(:capybara_element2) { double }
        before do
          expect(session).to receive(:all).with(:xpath, './/div').once { [capybara_element1, capybara_element2] }
        end
        it 'should return collection of sections' do
          res = subject
          expect(res.size).to eq(2)
          expect(res.first).to be_a(section_class)
          expect(res.last).to be_a(section_class)
        end
      end
      describe '#has_name_section?' do
        subject { web_page_object.send(:has_foo_section?) }
        before { expect(session).to receive(:has_selector?).with(:xpath, './/div').once { true } }
        it { is_expected.to eq(true) }
      end
      describe '#has_no_name_element?' do
        subject { web_page_object.send(:has_no_foo_section?) }
        before { expect(session).to receive(:has_no_selector?).with(:xpath, './/div').once { true } }
        it { is_expected.to eq(true) }
      end
    end

    context 'when section with 2 arguments without block' do
      let(:web_page_object) { web_page_class.new }
      let(:session) { double(:session) }
      before do
        allow(Capybara).to receive(:current_session) { session }
        web_page_class.class_eval do
          section :foo, '.some_class'
        end
      end
      describe '#name_section' do
        let(:capybara_element) { double }
        subject { web_page_object.send(:foo_section) }
        before { expect(session).to receive(:find).with('.some_class').once { capybara_element } }
        it { is_expected.to be_a(section_class) }
      end
      describe '#name_sections' do
        subject { web_page_object.send(:foo_sections) }
        let(:capybara_element1) { double }
        let(:capybara_element2) { double }
        before do
          expect(session).to receive(:all).with('.some_class').once { [capybara_element1, capybara_element2] }
        end
        it 'should return collection of sections' do
          res = subject
          expect(res.size).to eq(2)
          expect(res.first).to be_a(section_class)
          expect(res.last).to be_a(section_class)
        end
      end
      describe '#has_name_section?' do
        subject { web_page_object.send(:has_foo_section?) }
        before { expect(session).to receive(:has_selector?).with('.some_class').once { true } }
        it { is_expected.to eq(true) }
      end
      describe '#has_no_name_element?' do
        subject { web_page_object.send(:has_no_foo_section?) }
        before { expect(session).to receive(:has_no_selector?).with('.some_class').once { true } }
        it { is_expected.to eq(true) }
      end
    end
  end
end
