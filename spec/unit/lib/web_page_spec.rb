require 'spec_helper'
require 'howitzer/web_page'
require 'howitzer/capybara/settings'

RSpec.describe WebPage do
  describe '.open' do
    let(:url_value) { 'google.com' }
    let(:retryable) { double }
    let(:check_correct_page_loaded) { double }
    let(:other_instance) { described_class.instance }
    subject { described_class.open(url_value) }
    it do
      expect(log).to receive(:info).with("Open WebPage page by 'google.com' url").once.ordered
      expect(described_class).to receive(:retryable).ordered.once.and_call_original
      expect(described_class).to receive(:visit).with(url_value).once.ordered
      expect(described_class).to receive(:given).once.ordered
      subject
    end
  end

  describe '.given' do
    subject { described_class.given }
    before do
      expect(described_class).to receive(:wait_for_opened).with(no_args).once
      expect(described_class).to receive(:instance) { true }
    end
    it { is_expected.to be_truthy }
  end

  describe '.title' do
    let(:page) { double }
    subject { described_class.instance.title }
    before do
      allow_any_instance_of(described_class).to receive(:check_validations_are_defined!) { true }
      allow(described_class.instance).to receive(:current_url) { 'google.com' }
    end
    it do
      expect(described_class.instance).to receive(:page) { page }
      expect(page).to receive(:title)
      subject
    end
  end

  describe '.current_url' do
    let(:page) { double }
    subject { described_class.current_url }
    it do
      expect(described_class).to receive(:page) { page }
      expect(page).to receive(:current_url) { 'google.com' }
      is_expected.to eq('google.com')
    end
  end

  describe '.current_url' do
    let(:page) { double }
    subject { described_class.current_url }
    it do
      expect(described_class).to receive(:page) { page }
      expect(page).to receive(:current_url) { 'google.com' }
      is_expected.to eq('google.com')
    end
  end

  describe '.text' do
    let(:page) { double }
    let(:find) { double }
    subject { described_class.text }
    it do
      expect(described_class).to receive(:page) { page }
      expect(page).to receive(:find).with('body') { find }
      expect(find).to receive(:text) { 'some body text' }
      is_expected.to eq('some body text')
    end
  end

  describe '.current_page' do
    subject { described_class.current_page }
    context 'when matched_pages has no pages' do
      before { allow(described_class).to receive(:matched_pages) { [] } }
      it { is_expected.to eq(described_class::UnknownPage) }
    end
    context 'when matched_pages has more than 1 page' do
      let(:foo_page) { double(inspect: 'FooPage') }
      let(:bar_page) { double(inspect: 'BarPage') }
      before do
        allow(described_class).to receive(:current_url) { 'http://test.com' }
        allow(described_class).to receive(:title) { 'Test site' }
        allow(described_class).to receive(:matched_pages) { [foo_page, bar_page] }
      end
      it do
        expect(log).to receive(:error).with(
          Howitzer::AmbiguousPageMatchingError,
          "Current page matches more that one page class (FooPage, BarPage).\n" \
          "\tCurrent url: http://test.com\n\tCurrent title: Test site"
        ).once
        subject
      end
    end
    context 'when matched_pages has only 1 page' do
      let(:foo_page) { double(to_s: 'FooPage') }
      before { allow(described_class).to receive(:matched_pages) { [foo_page] } }
      it { is_expected.to eq(foo_page) }
    end
  end

  describe '.wait_for_opened' do
    subject { described_class.wait_for_opened }
    context 'when page is opened' do
      before { allow(described_class).to receive(:opened?) { true } }
      it { is_expected.to be_nil }
    end
    context 'when page is not opened' do
      before do
        allow(described_class).to receive(:current_page) { 'FooPage' }
        allow(described_class).to receive(:current_url) { 'http://test.com' }
        allow(described_class).to receive(:title) { 'Test site' }
        allow(settings).to receive(:timeout_small) { 0.1 }
        allow(described_class).to receive(:opened?) { false }
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

  describe '#initialize' do
    subject { described_class.send(:new) }
    before do
      expect_any_instance_of(described_class).to receive(:check_validations_are_defined!).once { true }
    end
    context 'when maximized_window is true' do
      before { allow(settings).to receive(:maximized_window) { true } }
      it do
        expect_any_instance_of(described_class).to receive_message_chain('page.driver.browser.manage.window.maximize')
        subject
      end
    end
    context 'when maximized_window is false' do
      before { allow(settings).to receive(:maximized_window) { false } }
      it do
        expect_any_instance_of(described_class).not_to receive('page')
        subject
      end
    end
  end

  describe 'inherited callback' do
    let!(:page_class) do
      Howitzer::Utils::PageValidator.instance_variable_set(:@pages, [])
      Class.new(described_class)
    end
    it { expect(Howitzer::Utils::PageValidator.pages).to eq([page_class]) }
    it 'can not be instantiated with new' do
      expect { page_class.new }.to raise_error(NoMethodError, "private method `new' called for #{page_class}")
    end
  end

  describe '#tinymce_fill_in' do
    subject { described_class.instance.tinymce_fill_in(name, options) }
    let(:name) { 'name' }
    let(:options) { { with: 'some content' } }
    before do
      allow(described_class.instance).to receive(:current_url) { 'google.com' }
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
        expect(described_class.instance).to receive(:page).exactly(3).times { page }
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
        expect(described_class.instance).to receive(:page) { page }
        expect(page).to receive(:execute_script).with("tinyMCE.get('name').setContent('some content')")
        subject
      end
    end
  end
  describe '#click_alert_box' do
    subject { described_class.instance.click_alert_box(flag_value) }
    before do
      allow(settings).to receive(:driver) { driver_name }
      allow(settings).to receive(:timeout_tiny) { 0 }
      allow(described_class.instance).to receive(:current_url) { 'google.com' }
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
        expect(described_class.instance).to receive(:page) { page }
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
        expect(described_class.instance).to receive(:page) { page }
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
        expect(described_class.instance).to receive(:page) { page }
        expect(page).to receive(:evaluate_script).with('window.confirm = function() { return true; }')
        subject
      end
    end
    context 'when flag false and wrong driver specified' do
      let(:driver_name) { 'ff' }
      let(:flag_value) { false }
      let(:page) { double }
      it do
        expect(described_class.instance).to receive(:page) { page }
        expect(page).to receive(:evaluate_script).with('window.confirm = function() { return false; }')
        subject
      end
    end
  end

  describe '#js_click' do
    subject { described_class.instance.js_click('.some_class') }
    before do
      allow(settings).to receive(:timeout_tiny) { 0.1 }
      allow(described_class.instance).to receive(:current_url) { 'google.com' }
    end
    let(:page) { double }
    it do
      expect(described_class.instance).to receive(:page) { page }
      expect(page).to receive(:execute_script).with("$('.some_class').trigger('click')")
      subject
    end
  end

  describe '#reload' do
    let(:wait_for_url) { double }
    subject { described_class.instance.reload }
    let(:visit) { double }
    before do
      allow(described_class.instance).to receive(:current_url) { 'google.com' }
      stub_const('WebPage::URL_PATTERN', 'pattern')
      allow(wait_for_url).to receive('pattern') { true }
    end
    it do
      expect(log).to receive(:info) { "Reload 'google.com'" }
      expect(described_class.instance).to receive(:visit).with('google.com')
      subject
    end
  end
end
