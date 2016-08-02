require 'spec_helper'
RSpec.shared_examples :dynamic_section_methods do
  let(:web_page_object) { web_page_class.new }

  describe '#name_section' do
    let(:capybara_element) { double }
    subject { web_page_object.send("#{section_name}_section") }
    before { expect(session).to receive(:find).with(*finder_args).once { capybara_element } }
    it { is_expected.to be_a(section_class) }
  end
  describe '#name_sections' do
    subject { web_page_object.send("#{section_name}_sections") }
    let(:capybara_element1) { double }
    let(:capybara_element2) { double }
    before do
      expect(session).to receive(:all).with(*finder_args).once { [capybara_element1, capybara_element2] }
    end
    it 'should return collection of sections' do
      res = subject
      expect(res.size).to eq(2)
      expect(res.first).to be_a(section_class)
      expect(res.last).to be_a(section_class)
    end
  end
  describe '#has_name_section?' do
    subject { web_page_object.send("has_#{section_name}_section?") }
    before { expect(session).to receive(:has_selector?).with(*finder_args).once { true } }
    it { is_expected.to eq(true) }
  end
  describe '#has_no_name_element?' do
    subject { web_page_object.send("has_no_#{section_name}_section?") }
    before { expect(session).to receive(:has_no_selector?).with(*finder_args).once { true } }
    it { is_expected.to eq(true) }
  end
end
