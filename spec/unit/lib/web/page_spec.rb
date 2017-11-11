require 'spec_helper'
require 'howitzer/web/page'
require 'howitzer/web/blank_page'

RSpec.describe Howitzer::Web::Page do
  let(:session) { double(:session) }
  before { allow(Capybara).to receive(:current_session) { session } }
  describe '.open' do
    let(:retryable) { double }
    let(:check_correct_page_loaded) { double }
    let(:other_instance) { described_class.instance }

    context 'when custom user_agent specified' do
      let(:url_value) { 'http://example.com/users' }
      let(:driver) { double }
      subject { described_class.open(validate: false) }
      before do
        allow(Howitzer).to receive(:user_agent) { 'user_agent' }
        allow(described_class).to receive(:retryable)
        allow(described_class).to receive(:expanded_url)
        allow(Howitzer::Log).to receive(:info)
      end
      context 'with webkit driver' do
        before { allow(Howitzer).to receive(:driver) { 'webkit' } }
        it do
          expect(Capybara).to receive_message_chain(:current_session, :driver) { driver }
          expect(driver).to receive(:header).with('User-Agent', Howitzer.user_agent)
          subject
        end
      end
      context 'with poltergeist driver' do
        before { allow(Howitzer).to receive(:driver) { 'poltergeist' } }
        it do
          expect(Capybara).to receive_message_chain(:current_session, :driver) { driver }
          expect(driver).to receive(:add_headers).with('User-Agent' => Howitzer.user_agent)
          subject
        end
      end
    end

    context 'when validate missing' do
      context 'when params present' do
        let(:url_value) { 'http://example.com/users/1' }
        subject { described_class.open(id: 1) }
        it do
          expect(described_class).to receive(:expanded_url).with({ id: 1 }, nil) { url_value }.once.ordered
          expect(Howitzer::Log).to receive(:info)
            .with("Open #{described_class} page by '#{url_value}' url").once.ordered
          expect(described_class).to receive(:retryable).ordered.once.and_call_original
          expect(session).to receive(:visit).with(url_value).once.ordered
          expect(described_class).to receive(:given).once.ordered.and_return(true)
          expect(subject).to eq(true)
        end
      end
      context 'when custom processor specified' do
        let(:custom_processor) { double }
        let(:url_value) { 'http://example.com/users/1' }
        subject { described_class.open(id: 1, url_processor: custom_processor) }
        it do
          expect(described_class).to receive(:expanded_url).with({ id: 1 }, custom_processor) { url_value }.once.ordered
          expect(Howitzer::Log).to receive(:info)
            .with("Open #{described_class} page by '#{url_value}' url").once.ordered
          expect(described_class).to receive(:retryable).ordered.once.and_call_original
          expect(session).to receive(:visit).with(url_value).once.ordered
          expect(described_class).to receive(:given).once.ordered.and_return(true)
          expect(subject).to eq(true)
        end
      end
      context 'when params missing' do
        let(:url_value) { 'http://example.com/users' }
        subject { described_class.open }
        it do
          expect(described_class).to receive(:expanded_url).with({}, nil).and_return(url_value).once.ordered
          expect(Howitzer::Log).to receive(:info)
            .with("Open #{described_class} page by '#{url_value}' url").once.ordered
          expect(described_class).to receive(:retryable).ordered.once.and_call_original
          expect(session).to receive(:visit).with(url_value).once.ordered
          expect(described_class).to receive(:given).once.ordered.and_return(true)
          expect(subject).to eq(true)
        end
      end
    end
    context 'when validate: false' do
      let(:url_value) { 'http://example.com/users' }
      subject { described_class.open(validate: false) }
      it do
        expect(described_class).to receive(:expanded_url).with({}, nil).and_return(url_value).once.ordered
        expect(Howitzer::Log).to receive(:info).with("Open #{described_class} page by '#{url_value}' url").once.ordered
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
        expect(described_class).to receive(:expanded_url).with({ id: 1 }, nil).and_return(url_value).once.ordered
        expect(Howitzer::Log).to receive(:info).with("Open #{described_class} page by '#{url_value}' url").once.ordered
        expect(described_class).to receive(:retryable).ordered.once.and_call_original
        expect(session).to receive(:visit).with(url_value).once.ordered
        expect(described_class).to receive(:given).once.ordered.and_return(true)
        expect(subject).to eq(true)
      end
    end
  end

  describe '.given' do
    subject { described_class.given }
    before do
      expect(described_class).to receive(:displayed?).with(no_args).once
      expect(described_class).to receive(:instance).and_return(true)
    end
    it { is_expected.to be_truthy }
  end

  describe '.title' do
    let(:page) { double }
    subject { described_class.instance.title }
    before do
      allow_any_instance_of(described_class).to receive(:check_validations_are_defined!).and_return(true)
      allow(session).to receive(:current_url).and_return('google.com')
    end
    it do
      expect(session).to receive(:title)
      subject
    end
  end

  describe '.current_page' do
    subject { described_class.current_page }
    context 'when matched_pages has no pages' do
      before { allow(described_class).to receive(:matched_pages).and_return([]) }
      it { is_expected.to eq(described_class::UnknownPage) }
    end
    context 'when matched_pages has more than 1 page' do
      let(:foo_page) { double(inspect: 'FooPage') }
      let(:bar_page) { double(inspect: 'BarPage') }
      before do
        allow_any_instance_of(described_class).to receive(:check_validations_are_defined!).and_return(true)
        allow(session).to receive(:current_url).and_return('http://test.com')
        allow(session).to receive(:title) { 'Test site' }
        allow(described_class).to receive(:matched_pages).and_return([foo_page, bar_page])
      end
      it do
        expect { subject }.to raise_error(
          Howitzer::AmbiguousPageMatchingError,
          "Current page matches more that one page class (FooPage, BarPage).\n" \
          "\tCurrent url: http://test.com\n\tCurrent title: Test site"
        )
      end
    end
    context 'when matched_pages has only 1 page' do
      let(:foo_page) { double(to_s: 'FooPage') }
      before { allow(described_class).to receive(:matched_pages).and_return([foo_page]) }
      it { is_expected.to eq(foo_page) }
    end
  end

  describe '.displayed?' do
    subject { described_class.displayed? }
    context 'when page is opened' do
      before { allow(described_class).to receive(:opened?).and_return(true) }
      it { is_expected.to eq(true) }
    end
    context 'when page is not opened' do
      before do
        allow(described_class).to receive(:current_page).and_return('FooPage')
        allow(session).to receive(:current_url).and_return('http://test.com')
        allow(session).to receive(:title).and_return('Test site')
        allow(described_class).to receive(:opened?).and_return(false)
      end
      it do
        expect { subject }.to raise_error(
          Howitzer::IncorrectPageError,
          "Current page: FooPage, expected: #{described_class}.\n" \
          "\tCurrent url: http://test.com\n\tCurrent title: Test site"
        )
      end
    end
  end

  describe '.current_url' do
    before { allow(Capybara).to receive_message_chain(:current_session, :current_url).and_return('http://example.com') }
    it 'should return current url page' do
      expect(Howitzer::Web::Page.current_url).to eq('http://example.com')
    end
  end

  describe '.site' do
    let!(:base_class) do
      Class.new(described_class) do
        site 'https://base.com'
      end
    end
    let!(:child_class1) do
      Class.new(base_class) do
        site 'https://child.com'
      end
    end
    let!(:child_class2) do
      Class.new(base_class)
    end
    let!(:child_class3) do
      Class.new(described_class)
    end
    it { expect(described_class.send(:site_value)).to eq('http://login:pass@my.website.com') }
    it { expect(base_class.send(:site_value)).to eq('https://base.com') }
    it { expect(child_class1.send(:site_value)).to eq('https://child.com') }
    it { expect(child_class2.send(:site_value)).to eq('https://base.com') }
    it { expect(child_class3.send(:site_value)).to eq('http://login:pass@my.website.com') }
    it 'should be protected' do
      expect { described_class.site('http://example.com') }.to raise_error(NoMethodError)
    end
  end

  describe '.expanded_url' do
    context 'when default url processor' do
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
                site 'http://example.com'
                path '/users{/id}'
              end
            end
            it { is_expected.to eq('http://example.com/users/1') }
          end
          context 'when root not specified' do
            let(:test_page) do
              Class.new(described_class) do
                path '/users{/id}'
              end
            end
            it { is_expected.to eq('http://login:pass@my.website.com/users/1') }
          end
        end
      end
      context 'when custom url processor' do
        let(:test_page) do
          Class.new(described_class) do
            site 'http://example.com'
            path '/users{/id}'
          end
        end
        let(:custom_processor_class) do
          Class.new do
            def self.restore(_name, value)
              value.tr('-', ' ')
            end

            def self.match(_name)
              '.*'
            end

            def self.validate(_name, value)
              !(value =~ /^[\w ]+$/).nil?
            end

            def self.transform(_name, value)
              value.tr(' ', '+')
            end
          end
        end
        subject { test_page.expanded_url({ id: 'hello world' }, custom_processor_class) }
        it { is_expected.to eq('http://example.com/users/hello+world') }
      end
      context 'when page url missing' do
        subject { described_class.expanded_url }
        it do
          expect { subject }.to raise_error(
            ::Howitzer::NoPathForPageError,
            "Please specify path for '#{described_class}' page. Example: path '/home'"
          )
        end
      end
    end
    context 'when params missing' do
      let(:test_page) do
        Class.new(described_class) do
          site 'http://example.com'
          path '/users'
        end
      end
      subject { test_page.expanded_url }
      it { is_expected.to eq('http://example.com/users') }
    end
  end

  describe '.path' do
    subject { described_class.send(:path, value) }
    before { subject }
    context 'when value is number' do
      let(:value) { 1 }
      it do
        expect(described_class.send(:path_value)).to eql '1'
        expect(described_class.private_methods(true)).to include(:path_value)
      end
    end
    context 'when value is string' do
      let(:value) { '/users' }
      it do
        expect(described_class.send(:path_value)).to eql '/users'
      end
    end
  end

  describe '#initialize' do
    subject { described_class.send(:new) }
    before do
      expect_any_instance_of(described_class).to receive(:check_validations_are_defined!).once.and_return(true)
    end
    context 'when maximized_window is true' do
      let(:driver) { double }
      before { allow(Howitzer).to receive(:maximized_window) { true } }
      it do
        expect_any_instance_of(described_class).to receive_message_chain('current_window.maximize')
        subject
      end
    end
    context 'when maximized_window is true and driver is headless_chrome' do
      before do
        allow(Howitzer).to receive(:maximized_window) { true }
        allow(Capybara).to receive(:current_driver) { 'headless_chrome' }
      end
      it do
        expect_any_instance_of(described_class).not_to receive('current_window.maximize')
        subject
      end
    end
    context 'when maximized_window is false' do
      before { allow(Howitzer).to receive(:maximized_window) { false } }
      it do
        expect_any_instance_of(described_class).not_to receive('current_window.maximize')
        subject
      end
    end
  end

  describe 'inherited callback' do
    let(:page_class) { Class.new(described_class) }
    it 'can not be instantiated with new' do
      expect { page_class.new }.to raise_error(NoMethodError, "private method `new' called for #{page_class}")
    end
  end

  describe '#reload' do
    let(:wait_for_url) { double }
    subject { described_class.instance.reload }
    let(:visit) { double }
    before do
      allow(session).to receive(:current_url).and_return('google.com')
    end
    it do
      expect(Howitzer::Log).to receive(:info).and_return("Reload 'google.com'")
      expect(session).to receive(:visit).with('google.com')
      subject
    end
  end

  describe '#capybara_context' do
    subject { described_class.instance.capybara_context }
    before { expect(Capybara).to receive(:current_session).and_return(:context) }
    it { is_expected.to eq(:context) }
  end

  describe 'includes proxied capybara methods' do
    let(:reciever) { described_class.instance }
    include_examples :capybara_methods_proxy
  end
end
