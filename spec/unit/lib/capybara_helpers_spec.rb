require 'spec_helper'
require 'howitzer/capybara_helpers'

RSpec.describe Howitzer::CapybaraHelpers do
  include Howitzer::CapybaraHelpers

  let(:settings) { double('settings') }
  let(:selenium_driver) { false }
  let(:selenium_grid_driver) { false }
  let(:phantomjs_driver) { false }
  let(:sauce_driver) { false }
  let(:test_object) { described_class }

  describe '#cloud_driver?' do
    subject { cloud_driver? }
    before { allow(settings).to receive(:driver) { driver_setting } }
    context 'when sauce driver' do
      let(:driver_setting) { :sauce }
      it { is_expected.to be_truthy }
    end
    context 'when testingbot driver' do
      let(:driver_setting) { :testingbot }
      it { is_expected.to be_truthy }
    end
    context 'when browserstack driver' do
      let(:driver_setting) { :browserstack }
      it { is_expected.to be_truthy }
    end
    context 'when not cloud driver' do
      let(:driver_setting) { :phantomjs }
      it { is_expected.to be_falsey }
    end
    context 'when driver specified as String' do
      let(:driver_setting) { 'testingbot' }
      it { is_expected.to be true }
    end
  end

  describe '#phantomjs_driver?' do
    subject { phantomjs_driver? }
    before { allow(settings).to receive(:driver) { driver_setting } }
    context 'when :phantomjs' do
      let(:driver_setting) { :phantomjs }
      it { is_expected.to be_truthy }
    end
    context 'when not :phantomjs' do
      let(:driver_setting) { :selenium }
      it { is_expected.to be_falsey }
    end
    context 'when :selenium_grid' do
      let(:driver_setting) { :selenium_grid }
      it { is_expected.to be_falsey }
    end
    context 'when driver specified as String' do
      let(:driver_setting) { 'phantomjs' }
      it { is_expected.to be_truthy }
    end
  end

  describe '#selenium_driver?' do
    subject { selenium_driver? }
    before { allow(settings).to receive(:driver) { driver_setting } }
    context 'when :selenium' do
      let(:driver_setting) { :selenium }
      it { is_expected.to be_truthy }
    end
    context 'when :selenium_grid' do
      let(:driver_setting) { :selenium_grid }
      it { is_expected.to be_falsey }
    end
    context 'when not :selenium' do
      let(:driver_setting) { :phantomjs }
      it { is_expected.to be_falsey }
    end
    context 'when driver specified as String' do
      let(:driver_setting) { 'selenium' }
      it { is_expected.to be_truthy }
    end
  end

  describe '#selenium_grid_driver?' do
    subject { selenium_grid_driver? }
    before { allow(settings).to receive(:driver) { driver_setting } }
    context 'when :selenium_grid' do
      let(:driver_setting) { :selenium_grid }
      it { is_expected.to be_truthy }
    end
    context 'when :selenium' do
      let(:driver_setting) { :selenium }
      it { is_expected.to be_falsey }
    end
    context 'when not :selenium' do
      let(:driver_setting) { :phantomjs }
      it { is_expected.to be_falsey }
    end
    context 'when driver specified as String' do
      let(:driver_setting) { 'selenium_grid' }
      it { is_expected.to be_truthy }
    end
  end

  describe '#ie_browser?' do
    subject { ie_browser? }
    before { allow(self).to receive(:selenium_grid_driver?) { selenium_grid_driver } }
    context 'when cloud_driver? is TRUE' do
      before { allow(self).to receive(:cloud_driver?) { true } }
      context 'settings.cloud_browser_name = :ie' do
        before { allow(settings).to receive(:cloud_browser_name) { :ie } }
        it { is_expected.to be_truthy }
      end
      context 'settings.cloud_browser_name = :iexplore' do
        before { allow(settings).to receive(:cloud_browser_name) { :iexplore } }
        it { is_expected.to be_truthy }
      end
      context 'settings.cloud_browser_name = :chrome' do
        before { allow(settings).to receive(:cloud_browser_name) { :chrome } }
        it { is_expected.to be_falsey }
      end
      context 'settings.cloud_browser_name is not specified' do
        before { allow(settings).to receive(:cloud_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::CloudBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::CloudBrowserNotSpecifiedError)
        end
      end
    end
    context 'when cloud_driver? is FALSE' do
      before do
        allow(self).to receive(:cloud_driver?) { false }
        allow(self).to receive(:selenium_driver?) { selenium_driver }
      end
      context 'when selenium_driver? is TRUE' do
        let(:selenium_driver) { true }
        context 'settings.sel_browser = :ie' do
          before { allow(settings).to receive(:sel_browser) { :ie } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :iexplore' do
          before { allow(settings).to receive(:sel_browser) { :iexplore } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :chrome' do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sel_browser is not specified' do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SelBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
      context 'when selenium_driver? is FALSE' do
        it { is_expected.to be_falsey }
      end
      context 'when selenium_grid_driver? is TRUE' do
        let(:selenium_grid_driver) { true }
        context 'settings.sel_browser = :ie' do
          before { allow(settings).to receive(:sel_browser) { :ie } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :iexplore' do
          before { allow(settings).to receive(:sel_browser) { :iexplore } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :chrome' do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sel_browser is not specified' do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SelBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
      context 'when selenium_grid_driver? is FALSE' do
        it { is_expected.to be_falsey }
      end
    end
    context 'when selenium_driver? is TRUE' do
      before do
        allow(self).to receive(:selenium_driver?) { selenium_driver }
        allow(self).to receive(:cloud_driver?) { false }
      end
      context 'when selenium_driver? is TRUE' do
        let(:selenium_driver) { true }
        context 'settings.sel_browser = :ie' do
          before { allow(settings).to receive(:sel_browser) { :ie } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :iexplore' do
          before { allow(settings).to receive(:sel_browser) { :iexplore } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :chrome' do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sel_browser is not specified' do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SelBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
    end
    context 'when selenium_driver? is FALSE' do
      before { allow(self).to receive(:selenium_driver?) { false } }
      context 'when cloud_driver? is TRUE' do
        before { allow(self).to receive(:cloud_driver?) { true } }
        context 'settings.cloud_browser_name = :ie' do
          before do
            allow(settings).to receive(:cloud_browser_name) { :ie }
            allow(settings).to receive(:cloud_browser_version) { 9 }
          end
          it { is_expected.to be_truthy }
        end
        context 'settings.cloud_browser_name = :iexplore' do
          before do
            allow(settings).to receive(:cloud_browser_name) { :iexplore }
            allow(settings).to receive(:cloud_browser_version) { 9 }
          end
          it { is_expected.to be_truthy }
        end
        context 'settings.cloud_browser_name = :firefox' do
          before do
            allow(settings).to receive(:cloud_browser_name) { :firefox }
            allow(settings).to receive(:cloud_browser_version) { 8 }
          end
          it { is_expected.to be_falsey }
        end
        context 'settings.cloud_browser_name is not specified' do
          before { allow(settings).to receive(:cloud_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::CloudBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::CloudBrowserNotSpecifiedError)
          end
        end
      end
    end
  end

  describe '#ff_browser?' do
    subject { ff_browser? }
    before do
      allow(self).to receive(:selenium_grid_driver?) { selenium_grid_driver }
    end
    context 'when cloud_driver? is TRUE' do
      before { allow(self).to receive(:cloud_driver?) { true } }
      context 'settings.cloud_browser_name = :ff' do
        before { allow(settings).to receive(:cloud_browser_name) { :ff } }
        it { is_expected.to be_truthy }
      end
      context 'settings.cloud_browser_name = :firefox' do
        before { allow(settings).to receive(:cloud_browser_name) { :firefox } }
        it { is_expected.to be_truthy }
      end
      context 'settings.cloud_browser_name = :chrome' do
        before { allow(settings).to receive(:cloud_browser_name) { :chrome } }
        it { is_expected.to be_falsey }
      end
      context 'settings.cloud_browser_name is not specified' do
        before { allow(settings).to receive(:cloud_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::CloudBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::CloudBrowserNotSpecifiedError)
        end
      end
    end
    context 'when cloud_driver? is FALSE' do
      before do
        allow(self).to receive(:cloud_driver?) { false }
        allow(self).to receive(:selenium_driver?) { selenium_driver }
      end
      context 'when selenium_driver? is TRUE' do
        let(:selenium_driver) { true }
        context 'settings.sel_browser = :ff' do
          before { allow(settings).to receive(:sel_browser) { :ff } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :firefox' do
          before { allow(settings).to receive(:sel_browser) { :firefox } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :chrome' do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sel_browser is not specified' do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SelBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
      context 'when selenium_driver? is FALSE' do
        it { is_expected.to be_falsey }
      end
    end
    context 'when selenium_driver? is TRUE' do
      before { allow(self).to receive(:cloud_driver?) { false } }
      before { allow(self).to receive(:selenium_driver?) { selenium_driver } }
      context 'when selenium_driver? is TRUE' do
        let(:selenium_driver) { true }
        context 'settings.sel_browser = :ff' do
          before { allow(settings).to receive(:sel_browser) { :ff } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :firefox' do
          before { allow(settings).to receive(:sel_browser) { :firefox } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :chrome' do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sel_browser is not specified' do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SelBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
    end
    context 'when selenium_driver? is FALSE' do
      before { allow(self).to receive(:selenium_driver?) { false } }
      context 'when cloud_driver? is TRUE' do
        before { allow(self).to receive(:cloud_driver?) { true } }
        context 'settings.cloud_browser_name = :firefox' do
          before do
            allow(settings).to receive(:cloud_browser_name) { :firefox }
            allow(settings).to receive(:cloud_browser_version) { 8 }
          end
          it { is_expected.to be_truthy }
        end
        context 'settings.cloud_browser_name = :ff' do
          before do
            allow(settings).to receive(:cloud_browser_name) { :ff }
            allow(settings).to receive(:cloud_browser_version) { 8 }
          end
          it { is_expected.to be_truthy }
        end
        context 'settings.cloud_browser_name = :iexplore' do
          before do
            allow(settings).to receive(:cloud_browser_name) { :iexplore }
            allow(settings).to receive(:cloud_browser_version) { 9 }
          end
          it { is_expected.to be_falsey }
        end
        context 'settings.cloud_browser_name is not specified' do
          before { allow(settings).to receive(:cloud_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::CloudBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::CloudBrowserNotSpecifiedError)
          end
        end
      end
      context 'when selenium_grid_driver? is TRUE' do
        before { allow(self).to receive(:selenium_grid_driver?) { selenium_grid_driver } }
        before { allow(self).to receive(:cloud_driver?) { false } }
        context 'when selenium_grid_driver? is TRUE' do
          let(:selenium_grid_driver) { true }
          context 'settings.sel_browser = :ff' do
            before { allow(settings).to receive(:sel_browser) { :ff } }
            it { is_expected.to be_truthy }
          end
          context 'settings.sel_browser = :firefox' do
            before { allow(settings).to receive(:sel_browser) { :firefox } }
            it { is_expected.to be_truthy }
          end
          context 'settings.sel_browser = :chrome' do
            before { allow(settings).to receive(:sel_browser) { :chrome } }
            it { is_expected.to be_falsey }
          end
          context 'settings.sel_browser is not specified' do
            before { allow(settings).to receive(:sel_browser) { nil } }
            it do
              expect(log).to receive(:error).with(
                Howitzer::SelBrowserNotSpecifiedError,
                'Please check your settings'
              ).once.and_call_original
              expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
            end
          end
        end
      end
      context 'when selenium_grid_driver? is FALSE' do
        before { allow(self).to receive(:selenium_grid_driver?) { false } }
        context 'when cloud_driver? is TRUE' do
          before { allow(self).to receive(:cloud_driver?) { true } }
          context 'settings.cloud_browser_name = :firefox' do
            before do
              allow(settings).to receive(:cloud_browser_name) { :firefox }
              allow(settings).to receive(:cloud_browser_version) { 8 }
            end
            it { is_expected.to be_truthy }
          end
          context 'settings.cloud_browser_name = :ff' do
            before do
              allow(settings).to receive(:cloud_browser_name) { :ff }
              allow(settings).to receive(:cloud_browser_version) { 8 }
            end
            it { is_expected.to be_truthy }
          end
          context 'settings.cloud_browser_name = :iexplore' do
            before do
              allow(settings).to receive(:cloud_browser_name) { :iexplore }
              allow(settings).to receive(:cloud_browser_version) { 9 }
            end
            it { is_expected.to be_falsey }
          end
          context 'settings.cloud_browser_name is not specified' do
            before { allow(settings).to receive(:cloud_browser_name) { nil } }
            it do
              expect(log).to receive(:error).with(
                Howitzer::CloudBrowserNotSpecifiedError,
                'Please check your settings'
              ).once.and_call_original
              expect { subject }.to raise_error(Howitzer::CloudBrowserNotSpecifiedError)
            end
          end
        end
      end
    end
  end

  describe '#chrome_browser?' do
    subject { chrome_browser? }
    before { allow(self).to receive(:selenium_grid_driver?) { selenium_grid_driver } }
    context 'when cloud_driver? is TRUE' do
      before { allow(self).to receive(:cloud_driver?) { true } }
      context 'settings.cloud_browser_name = :chrome' do
        before { allow(settings).to receive(:cloud_browser_name) { :chrome } }
        it { is_expected.to be_truthy }
      end
      context 'settings.cloud_browser_name = :firefox' do
        before { allow(settings).to receive(:cloud_browser_name) { :firefox } }
        it { is_expected.to be_falsey }
      end
      context 'settings.cloud_browser_name is not specified' do
        before { allow(settings).to receive(:cloud_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::CloudBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::CloudBrowserNotSpecifiedError)
        end
      end
    end
    context 'when selenium_driver? is TRUE' do
      before { allow(self).to receive(:cloud_driver?) { false } }
      before { allow(self).to receive(:selenium_driver?) { selenium_driver } }
      context 'when selenium_driver? is TRUE' do
        let(:selenium_driver) { true }
        context 'settings.sel_browser = :chrome' do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :firefox' do
          before { allow(settings).to receive(:sel_browser) { :firefox } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sel_browser is not specified' do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SelBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
    end
  end

  describe '#safari_browser?' do
    subject { safari_browser? }
    before { allow(self).to receive(:selenium_grid_driver?) { selenium_grid_driver } }
    context 'when cloud_driver? is TRUE' do
      before { allow(self).to receive(:cloud_driver?) { true } }
      context 'settings.cloud_browser_name = :safari' do
        before { allow(settings).to receive(:cloud_browser_name) { :safari } }
        it { is_expected.to be_truthy }
      end
      context 'settings.cloud_browser_name = :firefox' do
        before { allow(settings).to receive(:cloud_browser_name) { :firefox } }
        it { is_expected.to be_falsey }
      end
      context 'settings.cloud_browser_name is not specified' do
        before { allow(settings).to receive(:cloud_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::CloudBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::CloudBrowserNotSpecifiedError)
        end
      end
    end
    context 'when sauce_driver? is FALSE' do
      before { allow(self).to receive(:selenium_driver?) { selenium_driver } }
      before { allow(self).to receive(:cloud_driver?) { false } }
      context 'when selenium_driver? is TRUE' do
        let(:selenium_driver) { true }
        context 'settings.sel_browser = :safari' do
          before { allow(settings).to receive(:sel_browser) { :safari } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :firefox' do
          before { allow(settings).to receive(:sel_browser) { :firefox } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sel_browser is not specified' do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SelBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
      context 'when selenium_driver? is FALSE' do
        it { is_expected.to be_falsey }
      end
    end
    context 'when selenium_driver? is TRUE' do
      before { allow(self).to receive(:cloud_driver?) { false } }
      before { allow(self).to receive(:selenium_driver?) { selenium_driver } }
      context 'when selenium_driver? is TRUE' do
        let(:selenium_driver) { true }
        context 'settings.sel_browser = :safari' do
          before { allow(settings).to receive(:sel_browser) { :safari } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sel_browser = :firefox' do
          before { allow(settings).to receive(:sel_browser) { :firefox } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sel_browser is not specified' do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SelBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
    end
  end
  describe '#duration' do
    context 'when more than hour' do
      it { expect(duration(10_000)).to eq('[2h 46m 40s]') }
    end
    context 'when 1 hour exactly' do
      it { expect(duration(3600)).to eq('[1h 0m 0s]') }
    end
    context 'when 0 hours and more than minute' do
      it { expect(duration(2000)).to eq('[33m 20s]') }
    end
    context 'when 1 minute exactly' do
      it { expect(duration(60)).to eq('[1m 0s]') }
    end
    context 'when less than minute' do
      it { expect(duration(45)).to eq('[0m 45s]') }
    end
    context 'when zero' do
      it { expect(duration(0)).to eq('[0m 0s]') }
    end
  end

  describe '.sauce_resource_path' do
    subject { sauce_resource_path(kind) }
    let(:name) { 'test_name' }
    before do
      allow(settings).to receive(:cloud_auth_login) { 'vlad' }
      allow(settings).to receive(:cloud_auth_pass) { '11111' }
      allow(self).to receive(:session_id) { '12341234' }
    end
    context 'when kind video' do
      let(:kind) { :video }
      it { is_expected.to eql('https://vlad:11111@saucelabs.com/rest/vlad/jobs/12341234/results/video.flv') }
    end
    context 'when kind server_log' do
      let(:kind) { :server_log }
      it { is_expected.to eql('https://vlad:11111@saucelabs.com/rest/vlad/jobs/12341234/results/selenium-server.log') }
    end
    context 'when unknown kind' do
      let(:kind) { :unknown }
      it { expect { subject }.to raise_error(ArgumentError, "Unknown 'unknown' kind") }
    end
  end

  describe '.update_sauce_resource_path' do
    subject { update_sauce_job_status }
    before  do
      allow(settings).to receive(:cloud_auth_login) { 'vlad1' }
      allow(settings).to receive(:cloud_auth_pass) { '22222' }
      allow(self).to receive(:session_id) { '12341234' }
      stub_const('RestClient', double)
    end

    it do
      expect(RestClient).to receive(:put).with(
        'http://vlad1:22222@saucelabs.com/rest/v1/vlad1/jobs/12341234',
        '{}',
        content_type: :json,
        accept: :json
      ).once
      subject
    end
  end

  describe '.suite_name' do
    subject { suite_name }
    before do
      allow(settings).to receive(:cloud_browser_name) { 'ie' }
    end

    context 'when environment present' do
      let(:rake_task) { 'features:bvt' }
      before { ENV['RAKE_TASK'] = rake_task }
      after { ENV['RAKE_TASK'] = nil }
      it { is_expected.to eql('FEATURES:BVT IE') }
    end
    context 'when environment empty' do
      before { ENV['RAKE_TASK'] = nil }
      it { is_expected.to eql('CUSTOM IE') }
    end
  end

  describe '.session_id' do
    subject { session_id }
    before do
      browser = double
      current_session = double
      driver = double
      instance_variable = double
      allow(Capybara).to receive(:current_session) { current_session }
      allow(current_session).to receive(:driver) { driver }
      allow(driver).to receive(:browser) { browser }
      allow(browser).to receive(:instance_variable_get).with(:@bridge) { instance_variable }
      allow(instance_variable).to receive(:session_id) { 'test' }
    end

    it { is_expected.to eql('test') }
  end

  describe '.prefix_name' do
    subject { prefix_name }
    context 'when RAKE_TASK present' do
      before { ENV['RAKE_TASK'] = 'Foo' }
      after { ENV['RAKE_TASK'] = nil }
      it { is_expected.to eq('FOO') }
    end
    context 'when rake_task_name empty' do
      it { is_expected.to eq('ALL') }
    end
  end

  describe '.load_driver_gem!' do
    subject { load_driver_gem!(:webkit, 'capybara-webkit', 'capybara-webkit') }
    context 'when possible to require' do
      before { allow(self).to receive(:require).with(:webkit) { true } }
      it { expect { subject }.not_to raise_error(LoadError) }
    end
    context 'when impossible to require' do
      it do
        expect { subject }.to raise_error(
          LoadError,
          "`:webkit` driver is unable to load `capybara-webkit`, please add `gem 'capybara-webkit'` to your Gemfile."
        )
      end
    end
  end
end
