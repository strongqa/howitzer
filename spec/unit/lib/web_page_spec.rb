require 'spec_helper'
require 'howitzer/web_page'
require 'howitzer/capybara/settings'

describe 'WebPage' do
  describe '.open' do
    let(:url_value) { 'google.com' }
    let(:retryable) { double }
    let(:check_correct_page_loaded) { double }
    let(:other_instance) { WebPage.instance }
    subject { WebPage.open(url_value) }
    it do
      expect(log).to receive(:info).with("Open WebPage page by 'google.com' url").once.ordered
      expect(WebPage).to receive(:retryable).ordered.once.and_call_original
      expect(WebPage).to receive(:visit).with(url_value).once.ordered
      expect(WebPage).to receive(:given).once.ordered
      subject
    end
  end

  describe '.given' do
    subject { WebPage.given }
    before do
      expect(WebPage).to receive(:wait_for_opened).with(no_args).once
      allow_any_instance_of(WebPage).to receive(:check_validations_are_defined!){ true }
    end
    it { expect(subject.class).to eql(WebPage) }
  end

  describe '.title' do
    let(:page) { double }
    subject { WebPage.instance.title }
    before do
      allow(WebPage.instance).to receive(:current_url) { 'google.com' }
    end
    it do
      expect(WebPage.instance).to receive(:page) { page }
      expect(page).to receive(:title)
      subject
    end
  end

  describe '.url' do
    let(:page) { double }
    subject { WebPage.url }
    it do
      expect(WebPage).to receive(:page) { page }
      expect(page).to receive(:current_url) { 'google.com' }
      is_expected.to eq('google.com')
    end
  end

  describe '.current_url' do
    let(:page) { double }
    subject { WebPage.current_url }
    it do
      expect(WebPage).to receive(:page) { page }
      expect(page).to receive(:current_url) { 'google.com' }
      is_expected.to eq('google.com')
    end
  end

  describe '.text' do
    let(:page) { double }
    let(:find) { double }
    subject { WebPage.text }
    it do
      expect(WebPage).to receive(:page) { page }
      expect(page).to receive(:find).with('body') { find }
      expect(find).to receive(:text) { 'some body text' }
      is_expected.to eq('some body text')
    end
  end

  describe '.current_page' do
    subject { WebPage.current_page }
    context 'when matched_pages has no pages' do
      before { allow(WebPage).to receive(:matched_pages){ [] } }
      it { is_expected.to eq(WebPage::UnknownPage) }
    end
    context 'when matched_pages has more than 1 page' do
      let(:foo_page) { double(inspect: 'FooPage') }
      let(:bar_page) { double(inspect: 'BarPage') }
      before do
        allow(WebPage).to receive(:current_url) { 'http://test.com' }
        allow(WebPage).to receive(:title) { 'Test site' }
        allow(WebPage).to receive(:matched_pages){ [foo_page, bar_page] }
      end
      it do
        expect(log).to receive(:error).with(
          Howitzer::AmbiguousPageMatchingError,
          "Current page matches more that one page class (FooPage, BarPage).\n\tCurrent url: http://test.com\n\tCurrent title: Test site"
        ).once
        subject
      end
    end
    context 'when matched_pages has only 1 page' do
      let(:foo_page) { double(to_s: 'FooPage') }
      before { allow(WebPage).to receive(:matched_pages){ [foo_page] } }
      it { is_expected.to eq(foo_page) }
    end
  end

  describe '.wait_for_opened' do
    subject { WebPage.wait_for_opened }
    context 'when page is opened' do
      before { allow(WebPage).to receive(:opened?) { true } }
      it { is_expected.to be_nil }
    end
    context 'when page is not opened' do
      before do
        allow(WebPage).to receive(:current_page) { 'FooPage' }
        allow(WebPage).to receive(:current_url) { 'http://test.com' }
        allow(WebPage).to receive(:title) { 'Test site' }
        allow(settings).to receive(:timeout_small) { 0.1 }
        allow(WebPage).to receive(:opened?) { false }
      end
      it do
        expect(log).to receive(:error).with(
          Howitzer::IncorrectPageError,
          "Current page: FooPage, expected: WebPage.\n\tCurrent url: http://test.com\n\tCurrent title: Test site"
        )
        subject
      end
    end
  end

  describe 'inherited callback' do
    let!(:page_class) do
      Howitzer::Utils::PageValidator.instance_variable_set(:@pages, [])
      Class.new(WebPage)
    end
    it { expect(Howitzer::Utils::PageValidator.pages).to eq([page_class]) }
    it 'can not be instantiated with new' do
      expect { page_class.new }.to raise_error(NoMethodError, "private method `new' called for #{page_class}")
    end
  end

  describe '#tinymce_fill_in' do
    subject { WebPage.instance.tinymce_fill_in(name,options) }
    let(:name) { 'name' }
    let(:options) { {with: 'some content'} }
    before do
      allow(WebPage.instance).to receive(:current_url) { 'google.com' }
      allow(settings).to receive(:driver) { driver_name }
    end
    context 'when correct driver specified' do
      let(:driver_name) { 'selenium' }
      let(:page) { double }
      let(:driver) { double }
      let(:browser) { double }
      let(:switch_to) { double }
      let(:find) { double }
      let(:native) { double }
      it do
        expect(WebPage.instance).to receive(:page).exactly(3).times { page }
        expect(page).to receive(:driver).ordered { driver }
        expect(driver).to receive(:browser).ordered { browser }
        expect(browser).to receive(:switch_to).ordered { switch_to }
        expect(switch_to).to receive(:frame).with('name_ifr').once

        expect(page).to receive(:find).with(:css, '#tinymce').ordered { find }
        expect(find).to receive(:native).ordered { native }
        expect(native).to receive(:send_keys).with('some content').once

        expect(page).to receive(:driver) { driver }
        expect(driver).to receive(:browser) { browser }
        expect(browser).to receive(:switch_to) { switch_to }
        expect(switch_to).to receive(:default_content)

        subject
      end
    end
    context 'when incorrect driver specified' do
      let(:driver_name) { 'ff' }
      let(:page) { double }
      it do
        expect(WebPage.instance).to receive(:page) { page }
        expect(page).to receive(:execute_script).with("tinyMCE.get('name').setContent('some content')")
        subject
      end
    end
  end
  describe '#click_alert_box' do
    subject { WebPage.instance.click_alert_box(flag_value) }
    before do
      allow(settings).to receive(:driver) { driver_name }
      allow(settings).to receive(:timeout_tiny) { 0 }
      allow(WebPage.instance).to receive(:current_url) { 'google.com' }
    end
    context 'when flag true and correct driver specified' do
      let(:flag_value) { true }
      let(:page) { double }
      let(:alert) { double }
      let(:driver) { double }
      let(:browser) { double }
      let(:switch_to) { double }
      let(:driver_name) { 'selenium' }
      it do
        expect(WebPage.instance).to receive(:page) { page }
        expect(page).to receive(:driver).ordered { driver }
        expect(driver).to receive(:browser).ordered { browser }
        expect(browser).to receive(:switch_to).ordered { switch_to }
        expect(switch_to).to receive(:alert).ordered { alert }
        expect(alert).to receive(:accept).once
        subject
      end
    end
    context 'when flag false and correct driver specified' do
      let(:flag_value) { false }
      let(:page) { double }
      let(:alert) { double }
      let(:driver) { double }
      let(:browser) { double }
      let(:switch_to) { double }
      let(:driver_name) { 'selenium' }
      it do
        expect(WebPage.instance).to receive(:page) { page }
        expect(page).to receive(:driver).ordered { driver }
        expect(driver).to receive(:browser).ordered { browser }
        expect(browser).to receive(:switch_to).ordered { switch_to }
        expect(switch_to).to receive(:alert).ordered { alert }
        expect(alert).to receive(:dismiss).once
        subject
      end
    end
    context 'when flag true and wrong driver specified' do
      let(:flag_value) { true }
      let(:page) { double }
      let(:driver_name) { 'ff' }
      it do
        expect(WebPage.instance).to receive(:page) { page }
        expect(page).to receive(:evaluate_script).with('window.confirm = function() { return true; }')
        subject
      end
    end
    context 'when flag false and wrong driver specified' do
      let(:driver_name) { 'ff' }
      let(:flag_value) { false }
      let(:page) { double }
      it do
        expect(WebPage.instance).to receive(:page) { page }
        expect(page).to receive(:evaluate_script).with('window.confirm = function() { return false; }')
        subject
      end
    end
  end

  describe '#js_click' do
    subject { WebPage.instance.js_click('.some_class') }
    before do
      allow(settings).to receive(:timeout_tiny) { 0.1 }
      allow(WebPage.instance).to receive(:current_url) { 'google.com' }
    end
    let(:page) { double }
    it do
      expect(WebPage.instance).to receive(:page) { page }
      expect(page).to receive(:execute_script).with("$('.some_class').trigger('click')")
      subject
    end

  end

  describe '#wait_for_title' do
    subject { WebPage.instance.wait_for_title(expected_title) }
    before do
      allow(settings).to receive(:timeout_small) { 0.1 }
      allow(WebPage.instance).to receive(:title) { 'title' }
    end
    context 'when title equals expected title' do
      let(:expected_title) { 'title' }
      it do
        is_expected.to be_truthy
      end
    end
    context 'when title not equals expected title' do
      let(:expected_title) { 'bad title' }
      let(:error) { Howitzer::IncorrectPageError }
      let(:error_message) { 'Current title: title, expected:  bad title' }
      it do
        expect(log).to receive(:error).with(error,error_message).once.and_call_original
        expect { subject }.to raise_error(error)
      end
    end
  end

  describe '#wait_for_url' do
    subject { WebPage.instance.wait_for_url(expected_url) }
    before do
      allow(settings).to receive(:timeout_small) { 0.1 }
      allow(WebPage.instance).to receive(:current_url) { 'google.com' }
    end
    context 'when current_url equals expected_url' do
      let(:expected_url) { 'google.com' }
      it { is_expected.to be_truthy }
    end
    context 'when current_url not equals expected_url' do
      let(:expected_url) { 'bad_url' }
      let(:error) { Howitzer::IncorrectPageError }
      let(:error_message) { "Current url: google.com, expected:  #{expected_url}"  }
      it do
        expect(log).to receive(:error).with(error, error_message).once.and_call_original
        expect { subject }.to raise_error(error)
      end
    end
  end

  describe '#reload' do
    let(:wait_for_url) { double }
    subject { WebPage.instance.reload }
    let(:visit) { double }
    let(:webpage) { double }
    before do
      allow(WebPage.instance).to receive(:current_url) { 'google.com' }
      stub_const('WebPage::URL_PATTERN', 'pattern')
      allow(wait_for_url).to receive('pattern') { true }
    end
    it do
      expect(log).to receive(:info) { "Reload 'google.com'" }
      expect(WebPage.instance).to receive(:visit).with('google.com')
      subject
    end
  end
end