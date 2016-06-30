require 'spec_helper'
require 'howitzer/web/page'
require 'howitzer/web/blank_page'
require 'howitzer/capybara_settings'

RSpec.describe Howitzer::Web::Page do
  let(:session) { double(:session) }
  before { allow(Capybara).to receive(:current_session) { session } }
  describe '.open' do
    let(:retryable) { double }
    let(:check_correct_page_loaded) { double }
    let(:other_instance) { described_class.instance }
    context 'when validate missing' do
      context 'when params present' do
        let(:url_value) { 'http://example.com/users/1' }
        subject { described_class.open(id: 1) }
        it do
          expect(described_class).to receive(:expanded_url).with(id: 1) { url_value }.once.ordered
          expect(log).to receive(:info).with("Open #{described_class} page by '#{url_value}' url").once.ordered
          expect(described_class).to receive(:retryable).ordered.once.and_call_original
          expect(session).to receive(:visit).with(url_value).once.ordered
          expect(described_class).to receive(:given).once.ordered { true }
          expect(subject).to eq(true)
        end
      end
      context 'when params missing' do
        let(:url_value) { 'http://example.com/users' }
        subject { described_class.open }
        it do
          expect(described_class).to receive(:expanded_url).with({}) { url_value }.once.ordered
          expect(log).to receive(:info).with("Open #{described_class} page by '#{url_value}' url").once.ordered
          expect(described_class).to receive(:retryable).ordered.once.and_call_original
          expect(session).to receive(:visit).with(url_value).once.ordered
          expect(described_class).to receive(:given).once.ordered { true }
          expect(subject).to eq(true)
        end
      end
    end
    context 'when validate: false' do
      let(:url_value) { 'http://example.com/users' }
      subject { described_class.open(validate: false) }
      it do
        expect(described_class).to receive(:expanded_url).with({}) { url_value }.once.ordered
        expect(log).to receive(:info).with("Open #{described_class} page by '#{url_value}' url").once.ordered
        expect(described_class).to receive(:retryable).ordered.once.and_call_original
        expect(session).to receive(:visit).with(url_value).once.ordered
        expect(described_class).not_to receive(:given)
        expect(subject).to be_nil
      end
    end
    context 'when validate: true with params' do
      let(:url_value) { 'http://example.com/users/1' }
      subject { described_class.open(validate: true, id: 1) }
      it do
        expect(described_class).to receive(:expanded_url).with(id: 1) { url_value }.once.ordered
        expect(log).to receive(:info).with("Open #{described_class} page by '#{url_value}' url").once.ordered
        expect(described_class).to receive(:retryable).ordered.once.and_call_original
        expect(session).to receive(:visit).with(url_value).once.ordered
        expect(described_class).to receive(:given).once.ordered { true }
        expect(subject).to eq(true)
      end
    end
  end

  describe '.given' do
    subject { described_class.given }
    before do
      expect(described_class).to receive(:displayed?).with(no_args).once
      expect(described_class).to receive(:instance) { true }
    end
    it { is_expected.to be_truthy }
  end

  describe '.title' do
    let(:page) { double }
    subject { described_class.instance.title }
    before do
      allow_any_instance_of(described_class).to receive(:check_validations_are_defined!) { true }
      allow(session).to receive(:current_url) { 'google.com' }
    end
    it do
      expect(session).to receive(:title)
      subject
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
        allow_any_instance_of(described_class).to receive(:check_validations_are_defined!) { true }
        allow(session).to receive(:current_url) { 'http://test.com' }
        allow(session).to receive(:title) { 'Test site' }
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

  describe '.displayed?' do
    subject { described_class.displayed? }
    context 'when page is opened' do
      before { allow(described_class).to receive(:opened?) { true } }
      it { is_expected.to eq(true) }
    end
    context 'when page is not opened' do
      before do
        allow(described_class).to receive(:current_page) { 'FooPage' }
        allow(session).to receive(:current_url) { 'http://test.com' }
        allow(session).to receive(:title) { 'Test site' }
        allow(settings).to receive(:timeout_small) { 0.1 }
        allow(described_class).to receive(:opened?) { false }
      end
      it do
        expect(log).to receive(:error).with(
          Howitzer::IncorrectPageError,
          "Current page: FooPage, expected: #{described_class}.\n" \
          "\tCurrent url: http://test.com\n\tCurrent title: Test site"
        )
        subject
      end
    end
  end

  describe '.root_url' do
    let(:url_value) { 'http://example.com' }
    it do
      described_class.send(:root_url, url_value)
      expect(described_class.instance_variable_get(:@root_url)).to eql url_value
    end
    it 'should be protected' do
      expect { described_class.root_url(url_value) }.to raise_error(NoMethodError)
    end
  end

  describe '.expanded_url' do
    context 'when params present' do
      subject { test_page.expanded_url(id: 1) }
      context 'when page url specified' do
        context 'when BlankPage' do
          let(:test_page) { Howitzer::Web::BlankPage }
          it { is_expected.to eq('about:blank') }
        end
        context 'when other page' do
          let(:test_page) do
            Class.new(described_class) do
              root_url 'http://example.com'
              url '/users{/id}'
            end
          end
          it { is_expected.to eq('http://example.com/users/1') }
        end
        context 'when root not specified' do
          let(:test_page) do
            Class.new(described_class) do
              url '/users{/id}'
            end
          end
          it { is_expected.to eq('http://my.website.com/users/1') }
        end
      end
      context 'when page url missing' do
        subject { described_class.expanded_url }
        it do
          expect { subject }.to raise_error(
            ::Howitzer::PageUrlNotSpecifiedError,
            "Please specify url for '#{described_class}' page. Example: url '/home'"
          )
        end
      end
    end
    context 'when params missing' do
      let(:test_page) do
        Class.new(described_class) do
          root_url 'http://example.com'
          url '/users'
        end
      end
      subject { test_page.expanded_url }
      it { is_expected.to eq('http://example.com/users') }
    end
  end

  describe '.url' do
    subject { described_class.send(:url, value) }
    before { subject }
    context 'when value is number' do
      let(:value) { 1 }
      it { expect(described_class.instance_variable_get(:@url_template)).to eq('1') }
    end
    context 'when value is string' do
      let(:value) { '/users' }
      it { expect(described_class.instance_variable_get(:@url_template)).to eq('/users') }
    end
  end

  describe '#initialize' do
    subject { described_class.send(:new) }
    before do
      expect_any_instance_of(described_class).to receive(:check_validations_are_defined!).once { true }
    end
    context 'when maximized_window is true' do
      let(:driver) { double }
      before { allow(settings).to receive(:maximized_window) { true } }
      it do
        expect_any_instance_of(described_class).to receive_message_chain('driver.browser.manage.window.maximize')
        subject
      end
    end
    context 'when maximized_window is false' do
      before { allow(settings).to receive(:maximized_window) { false } }
      it do
        expect_any_instance_of(described_class).not_to receive(:driver)
        subject
      end
    end
  end

  describe 'inherited callback' do
    let(:page_class) { Class.new(described_class) }
    context 'when abstract class without validations' do
      let!(:page_class) do
        Howitzer::Web::PageValidator.instance_variable_set(:@pages, [])
        Class.new(described_class)
      end
      it { expect(Howitzer::Web::PageValidator.pages).to eq([]) }
    end
    context 'when class has validations' do
      let!(:page_class) do
        allow(described_class).to receive(:validations) { { title: /some text/ } }
        Howitzer::Web::PageValidator.instance_variable_set(:@pages, [])
        Class.new(described_class)
      end
      it { expect(Howitzer::Web::PageValidator.pages).to eq([page_class]) }
    end
    it 'can not be instantiated with new' do
      expect { page_class.new }.to raise_error(NoMethodError, "private method `new' called for #{page_class}")
    end
  end

  describe '#click_alert_box' do
    subject { described_class.instance.click_alert_box(flag_value) }
    before do
      allow(settings).to receive(:driver) { driver_name }
      allow(settings).to receive(:timeout_tiny) { 0 }
      allow(session).to receive(:current_url) { 'google.com' }
      allow_any_instance_of(described_class).to receive(:check_validations_are_defined!) { true }
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
        expect(session).to receive(:driver).ordered { driver }
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
        expect(session).to receive(:driver).ordered { driver }
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
        expect(session).to receive(:evaluate_script).with('window.confirm = function() { return true; }')
        subject
      end
    end
    context 'when flag false and wrong driver specified' do
      let(:driver_name) { 'ff' }
      let(:flag_value) { false }
      let(:page) { double }
      it do
        expect(session).to receive(:evaluate_script).with('window.confirm = function() { return false; }')
        subject
      end
    end
  end

  describe '#reload' do
    let(:wait_for_url) { double }
    subject { described_class.instance.reload }
    let(:visit) { double }
    before do
      allow(session).to receive(:current_url) { 'google.com' }
    end
    it do
      expect(log).to receive(:info) { "Reload 'google.com'" }
      expect(session).to receive(:visit).with('google.com')
      subject
    end
  end
end
