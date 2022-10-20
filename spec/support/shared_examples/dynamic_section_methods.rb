require 'spec_helper'
RSpec.shared_examples :dynamic_section_methods do
  let(:web_page_object) { web_page_class.new }

  describe '#name_section' do
    let(:capybara_element) { double }
    context 'when passed only finder args' do
      subject { web_page_object.send("#{section_name}_section") }
      before { expect(session).to receive(:find).with(*finder_args).once.and_return(capybara_element) }
      it { is_expected.to be_a(section_class) }
    end

    context 'when passed finder args and key options' do
      subject { web_page_object.send("#{section_name}_section", wait: 10) }
      before do
        expect(session).to receive(:find).with(*finder_args,
                                               **finder_options).once.and_return(capybara_element)
      end
      it { is_expected.to be_a(section_class) }
    end
  end
  describe '#name_sections' do
    let(:capybara_element1) { double }
    let(:capybara_element2) { double }

    context 'when passed only finder args' do
      subject { web_page_object.send("#{section_name}_sections") }
      before do
        expect(session).to receive(:all).with(*finder_args).once.and_return([capybara_element1, capybara_element2])
      end
      it 'should return collection of sections' do
        res = subject
        expect(res.size).to eq(2)
        expect(res.first).to be_a(section_class)
        expect(res.last).to be_a(section_class)
      end
    end

    context 'when passed finder args and key options' do
      subject { web_page_object.send("#{section_name}_sections", wait: 10) }
      before do
        expect(session).to receive(:all).with(*finder_args,
                                              **finder_options).once.and_return([capybara_element1, capybara_element2])
      end
      it 'should return collection of sections' do
        res = subject
        expect(res.size).to eq(2)
        expect(res.first).to be_a(section_class)
        expect(res.last).to be_a(section_class)
      end
    end
  end
  describe '#has_name_section?' do
    context 'when passed only finder args' do
      subject { web_page_object.send("has_#{section_name}_section?") }
      before { expect(session).to receive(:has_selector?).with(*finder_args).once.and_return(true) }
      it { is_expected.to eq(true) }
    end

    context 'when passed finder args and key options' do
      subject { web_page_object.send("has_#{section_name}_section?", wait: 10) }
      before do
        expect(session).to receive(:has_selector?).with(*finder_args,
                                                        **finder_options).once.and_return(true)
      end
      it { is_expected.to eq(true) }
    end
  end
  describe '#has_no_name_element?' do
    context 'when passed only finder args' do
      subject { web_page_object.send("has_no_#{section_name}_section?") }
      before { expect(session).to receive(:has_no_selector?).with(*finder_args).once.and_return(true) }
      it { is_expected.to eq(true) }
    end

    context 'when passed finder args and key options' do
      subject { web_page_object.send("has_no_#{section_name}_section?", wait: 10) }
      before do
        expect(session).to receive(:has_no_selector?).with(*finder_args,
                                                           **finder_options).once.and_return(true)
      end
      it { is_expected.to eq(true) }
    end
  end
end
