require 'spec_helper'
RSpec.shared_examples :dynamic_section_methods do
  let(:web_page_object) { web_page_class.new }

  describe '#name_section' do
    let(:capybara_element) { double }
    context 'when no args' do
      subject { web_page_object.send("#{section_name}_section") }
      before do
        if expected_finder_options.blank?
          expect(session).to receive(:find).with(*expected_finder_args).once.and_return(capybara_element)
        else
          expect(session).to receive(:find).with(*expected_finder_args,
                                                 **expected_finder_options).once.and_return(capybara_element)
        end
      end
      it { is_expected.to be_a(section_class) }
    end

    context 'when custom options' do
      subject { web_page_object.send("#{section_name}_section", wait: 10) }
      before do
        expect(session).to receive(:find).with(
          *expected_finder_args,
          **expected_finder_options.merge(wait: 10)
        ).once.and_return(capybara_element)
      end
      it { is_expected.to be_a(section_class) }
    end
  end
  describe '#name_sections' do
    let(:capybara_element1) { double }
    let(:capybara_element2) { double }

    context 'when no args' do
      subject { web_page_object.send("#{section_name}_sections") }
      before do
        if expected_finder_options.blank?
          expect(session).to receive(:all).with(*expected_finder_args).once.and_return([capybara_element1,
                                                                                        capybara_element2])
        else
          expect(session).to receive(:all).with(*expected_finder_args,
                                                **expected_finder_options).once.and_return([capybara_element1,
                                                                                            capybara_element2])
        end
      end
      it 'should return collection of sections' do
        res = subject
        expect(res.size).to eq(2)
        expect(res.first).to be_a(section_class)
        expect(res.last).to be_a(section_class)
      end
    end

    context 'when custom options' do
      subject { web_page_object.send("#{section_name}_sections", wait: 10) }
      before do
        expect(session).to receive(:all).with(
          *expected_finder_args,
          **expected_finder_options.merge(wait: 10)
        ).once.and_return([capybara_element1, capybara_element2])
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
    context 'when no args' do
      subject { web_page_object.send("has_#{section_name}_section?") }
      before do
        if expected_finder_options.blank?
          expect(session).to receive(:has_selector?).with(*expected_finder_args).once.and_return(true)
        else
          expect(session).to receive(:has_selector?).with(*expected_finder_args,
                                                          **expected_finder_options).once.and_return(true)
        end
      end
      it { is_expected.to eq(true) }
    end

    context 'when custom options' do
      subject { web_page_object.send("has_#{section_name}_section?", wait: 10) }
      before do
        expect(session).to receive(:has_selector?).with(*expected_finder_args,
                                                        **expected_finder_options.merge(wait: 10)).once.and_return(true)
      end
      it { is_expected.to eq(true) }
    end
  end
  describe '#has_no_name_element?' do
    context 'when no args' do
      subject { web_page_object.send("has_no_#{section_name}_section?") }
      before do
        if expected_finder_options.blank?
          expect(session).to receive(:has_no_selector?).with(*expected_finder_args).once.and_return(true)
        else
          expect(session).to receive(:has_no_selector?).with(*expected_finder_args,
                                                             **expected_finder_options).once.and_return(true)
        end
      end
      it { is_expected.to eq(true) }
    end

    context 'when custom options' do
      subject { web_page_object.send("has_no_#{section_name}_section?", wait: 10) }
      before do
        expect(session).to receive(:has_no_selector?).with(
          *expected_finder_args,
          **expected_finder_options.merge(wait: 10)
        ).once.and_return(true)
      end
      it { is_expected.to eq(true) }
    end
  end
end
