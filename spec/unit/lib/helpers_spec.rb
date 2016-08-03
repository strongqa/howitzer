require 'spec_helper'
require 'howitzer/helpers'

RSpec.describe Howitzer::Helpers do
  include Howitzer::Helpers

  let(:settings) { double('settings') }
  let(:selenium_driver) { false }
  let(:selenium_grid_driver) { false }
  let(:phantomjs_driver) { false }
  let(:sauce_driver) { false }
  let(:testingbot_driver) { false }
  let(:test_object) { described_class }

  describe '#sauce_driver?' do
    subject { sauce_driver? }
    before { allow(settings).to receive(:driver) { driver_setting } }
    context 'when :sauce' do
      let(:driver_setting) { :sauce }
      it { is_expected.to be_truthy }
    end
    context 'when not :sauce' do
      let(:driver_setting) { :phantomjs }
      it { is_expected.to be_falsey }
    end
    context 'when driver specified as String' do
      let(:driver_setting) { 'sauce' }
      it { is_expected.to be true }
    end
    context 'when driver is not specified' do
      let(:driver_setting) { nil }
      it do
        expect(log).to receive(:error).with(
          Howitzer::DriverNotSpecifiedError,
          'Please check your settings'
        ).once.and_call_original
        expect { subject }.to raise_error(Howitzer::DriverNotSpecifiedError)
      end
    end
  end

  describe '#testingbot_driver?' do
    subject { testingbot_driver? }
    before { allow(settings).to receive(:driver) { driver_setting } }
    context 'when :testingbot' do
      let(:driver_setting) { :testingbot }
      it { is_expected.to be_truthy }
    end
    context 'when not :testingbot' do
      let(:driver_setting) { :phantomjs }
      it { is_expected.to be_falsey }
    end
    context 'when driver specified as String' do
      let(:driver_setting) { 'testingbot' }
      it { is_expected.to be_truthy }
    end
    context 'when driver is not specified' do
      let(:driver_setting) { nil }
      it do
        expect(log).to receive(:error).with(
          Howitzer::DriverNotSpecifiedError,
          'Please check your settings'
        ).once.and_call_original
        expect { subject }.to raise_error(Howitzer::DriverNotSpecifiedError)
      end
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
    context 'when driver is not specified' do
      let(:driver_setting) { nil }
      it do
        expect(log).to receive(:error).with(
          Howitzer::DriverNotSpecifiedError,
          'Please check your settings'
        ).once.and_call_original
        expect { subject }.to raise_error(Howitzer::DriverNotSpecifiedError)
      end
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
    context 'when driver is not specified' do
      let(:driver_setting) { nil }
      it do
        expect(log).to receive(:error).with(
          Howitzer::DriverNotSpecifiedError,
          'Please check your settings'
        ).once.and_call_original
        expect { subject }.to raise_error(Howitzer::DriverNotSpecifiedError)
      end
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
    context 'when driver is not specified' do
      let(:driver_setting) { nil }
      it do
        expect(log).to receive(:error).with(
          Howitzer::DriverNotSpecifiedError,
          'Please check your settings'
        ).once.and_call_original
        expect { subject }.to raise_error(Howitzer::DriverNotSpecifiedError)
      end
    end
  end

  describe '#ie_browser?' do
    subject { ie_browser? }
    before { allow(self).to receive(:sauce_driver?) { sauce_driver } }
    before { allow(self).to receive(:testingbot_driver?) { testingbot_driver } }
    before { allow(self).to receive(:selenium_grid_driver?) { selenium_grid_driver } }
    context 'when sauce_driver? is TRUE' do
      let(:sauce_driver) { true }
      context 'settings.sl_browser_name = :ie' do
        before { allow(settings).to receive(:sl_browser_name) { :ie } }
        it { is_expected.to be_truthy }
      end
      context 'settings.sl_browser_name = :iexplore' do
        before { allow(settings).to receive(:sl_browser_name) { :iexplore } }
        it { is_expected.to be_truthy }
      end
      context 'settings.sl_browser_name = :chrome' do
        before { allow(settings).to receive(:sl_browser_name) { :chrome } }
        it { is_expected.to be_falsey }
      end
      context 'settings.sl_browser_name is not specified' do
        before { allow(settings).to receive(:sl_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::SlBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
        end
      end
    end
    context 'when sauce_driver? is FALSE' do
      before { allow(self).to receive(:selenium_driver?) { selenium_driver } }
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
    context 'when testingbot_driver? is TRUE' do
      let(:testingbot_driver) { true }
      before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
      context 'settings.sel_browser = :ie' do
        before do
          allow(settings).to receive(:tb_browser_name) { :ie }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { is_expected.to be_truthy }
      end
      context 'settings.tb_browser_name = :iexplore' do
        before do
          allow(settings).to receive(:tb_browser_name) { :iexplore }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { is_expected.to be_truthy }
      end
      context 'settings.tb_browser_name = :firefox' do
        before do
          allow(settings).to receive(:tb_browser_name) { :firefox }
          allow(settings).to receive(:tb_browser_version) { 8 }
        end
        it { is_expected.to be_falsey }
      end
      context 'settings.tb_browser_name is not specified' do
        before { allow(settings).to receive(:tb_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::TbBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
        end
      end
    end
    context 'when testingbot_driver? is FALSE' do
      before { allow(self).to receive(:sauce_driver?) { sauce_driver } }
      context 'when sauce_driver? is TRUE' do
        let(:sauce_driver) { true }
        context 'settings.sl_browser_name = :ie' do
          before { allow(settings).to receive(:sl_browser_name) { :ie } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sl_browser_name = :iexplore' do
          before { allow(settings).to receive(:sl_browser_name) { :iexplore } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sl_browser_name = :chrome' do
          before { allow(settings).to receive(:sl_browser_name) { :chrome } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sl_browser_name is not specified' do
          before { allow(settings).to receive(:sl_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SlBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
          end
        end
      end
    end
    context 'when selenium_driver? is TRUE' do
      before { allow(self).to receive(:selenium_driver?) { selenium_driver } }
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
      context 'when testingbot_driver? is TRUE' do
        let(:testingbot_driver) { true }
        before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
        context 'settings.sl_browser_name = :ie' do
          before do
            allow(settings).to receive(:tb_browser_name) { :ie }
            allow(settings).to receive(:tb_browser_version) { 9 }
          end
          it { is_expected.to be_truthy }
        end
        context 'settings.tb_browser_name = :iexplore' do
          before do
            allow(settings).to receive(:tb_browser_name) { :iexplore }
            allow(settings).to receive(:tb_browser_version) { 9 }
          end
          it { is_expected.to be_truthy }
        end
        context 'settings.tb_browser_name = :firefox' do
          before do
            allow(settings).to receive(:tb_browser_name) { :firefox }
            allow(settings).to receive(:tb_browser_version) { 8 }
          end
          it { is_expected.to be_falsey }
        end
        context 'settings.tb_browser_name is not specified' do
          before { allow(settings).to receive(:tb_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::TbBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
          end
        end
      end
    end
  end

  describe '#ff_browser?' do
    subject { ff_browser? }
    before { allow(self).to receive(:sauce_driver?) { sauce_driver } }
    before { allow(self).to receive(:testingbot_driver?) { testingbot_driver } }
    before { allow(self).to receive(:selenium_grid_driver?) { selenium_grid_driver } }
    context 'when sauce_driver? is TRUE' do
      let(:sauce_driver) { true }
      context 'settings.sl_browser_name = :ff' do
        before { allow(settings).to receive(:sl_browser_name) { :ff } }
        it { is_expected.to be_truthy }
      end
      context 'settings.sl_browser_name = :firefox' do
        before { allow(settings).to receive(:sl_browser_name) { :firefox } }
        it { is_expected.to be_truthy }
      end
      context 'settings.sl_browser_name = :chrome' do
        before { allow(settings).to receive(:sl_browser_name) { :chrome } }
        it { is_expected.to be_falsey }
      end
      context 'settings.sl_browser_name is not specified' do
        before { allow(settings).to receive(:sl_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::SlBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
        end
      end
    end
    context 'when sauce_driver? is FALSE' do
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
      context 'when selenium_driver? is FALSE' do
        it { is_expected.to be_falsey }
      end
    end
    context 'when testingbot_driver? is TRUE' do
      let(:testingbot_driver) { true }
      before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
      context 'settings.tb_browser_name = :ff' do
        before do
          allow(settings).to receive(:tb_browser_name) { :ff }
          allow(settings).to receive(:tb_browser_version) { 8 }
        end
        it { is_expected.to be_truthy }
      end
      context 'settings.tb_browser_name = :firefox' do
        before do
          allow(settings).to receive(:tb_browser_name) { :firefox }
          allow(settings).to receive(:tb_browser_version) { 8 }
        end
        it { is_expected.to be_truthy }
      end
      context 'settings.tb_browser_name = :iexplore' do
        before do
          allow(settings).to receive(:tb_browser_name) { :iexplore }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { is_expected.to be_falsey }
      end
      context 'settings.tb_browser_name is not specified' do
        before { allow(settings).to receive(:tb_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::TbBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
        end
      end
    end
    context 'when testingbot_driver? is FALSE' do
      before { allow(self).to receive(:sauce_driver?) { sauce_driver } }
      context 'when sauce_driver? is TRUE' do
        let(:sauce_driver) { true }
        context 'settings.sl_browser_name = :ff' do
          before { allow(settings).to receive(:sl_browser_name) { :ff } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sl_browser_name = :firefox' do
          before { allow(settings).to receive(:sl_browser_name) { :firefox } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sl_browser_name = :chrome' do
          before { allow(settings).to receive(:sl_browser_name) { :chrome } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sl_browser_name is not specified' do
          before { allow(settings).to receive(:sl_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SlBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
          end
        end
      end
    end
    context 'when selenium_driver? is TRUE' do
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
      context 'when testingbot_driver? is TRUE' do
        let(:testingbot_driver) { true }
        before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
        context 'settings.tb_browser_name = :firefox' do
          before do
            allow(settings).to receive(:tb_browser_name) { :firefox }
            allow(settings).to receive(:tb_browser_version) { 8 }
          end
          it { is_expected.to be_truthy }
        end
        context 'settings.tb_browser_name = :ff' do
          before do
            allow(settings).to receive(:tb_browser_name) { :ff }
            allow(settings).to receive(:tb_browser_version) { 8 }
          end
          it { is_expected.to be_truthy }
        end
        context 'settings.tb_browser_name = :iexplore' do
          before do
            allow(settings).to receive(:tb_browser_name) { :iexplore }
            allow(settings).to receive(:tb_browser_version) { 9 }
          end
          it { is_expected.to be_falsey }
        end
        context 'settings.tb_browser_name is not specified' do
          before { allow(settings).to receive(:tb_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::TbBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
          end
        end
      end
      context 'when selenium_grid_driver? is TRUE' do
        before { allow(self).to receive(:selenium_grid_driver?) { selenium_grid_driver } }
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
        context 'when testingbot_driver? is TRUE' do
          let(:testingbot_driver) { true }
          before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
          context 'settings.tb_browser_name = :firefox' do
            before do
              allow(settings).to receive(:tb_browser_name) { :firefox }
              allow(settings).to receive(:tb_browser_version) { 8 }
            end
            it { is_expected.to be_truthy }
          end
          context 'settings.tb_browser_name = :ff' do
            before do
              allow(settings).to receive(:tb_browser_name) { :ff }
              allow(settings).to receive(:tb_browser_version) { 8 }
            end
            it { is_expected.to be_truthy }
          end
          context 'settings.tb_browser_name = :iexplore' do
            before do
              allow(settings).to receive(:tb_browser_name) { :iexplore }
              allow(settings).to receive(:tb_browser_version) { 9 }
            end
            it { is_expected.to be_falsey }
          end
          context 'settings.tb_browser_name is not specified' do
            before { allow(settings).to receive(:tb_browser_name) { nil } }
            it do
              expect(log).to receive(:error).with(
                Howitzer::TbBrowserNotSpecifiedError,
                'Please check your settings'
              ).once.and_call_original
              expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
            end
          end
        end
      end
    end
  end

  describe '#chrome_browser?' do
    subject { chrome_browser? }
    before { allow(self).to receive(:sauce_driver?) { sauce_driver } }
    before { allow(self).to receive(:testingbot_driver?) { testingbot_driver } }
    before { allow(self).to receive(:selenium_grid_driver?) { selenium_grid_driver } }
    context 'when sauce_driver? is TRUE' do
      let(:sauce_driver) { true }
      let(:testingbot_driver) { true }
      context 'settings.sl_browser_name = :chrome' do
        before { allow(settings).to receive(:sl_browser_name) { :chrome } }
        it { is_expected.to be_truthy }
      end
      context 'settings.sl_browser_name = :firefox' do
        before { allow(settings).to receive(:sl_browser_name) { :firefox } }
        it { is_expected.to be_falsey }
      end
      context 'settings.sl_browser_name is not specified' do
        before { allow(settings).to receive(:sl_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::SlBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
        end
      end
    end
    context 'when sauce_driver? is FALSE' do
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
      context 'when selenium_driver? is FALSE' do
        it { is_expected.to be_falsey }
      end
    end
    context 'when testingbot_driver? is TRUE' do
      let(:testingbot_driver) { true }
      before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
      context 'settings.tb_browser_name = :chrome' do
        before do
          allow(settings).to receive(:tb_browser_name) { :chrome }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { is_expected.to be_truthy }
      end
      context 'settings.tb_browser_name = :iexplore' do
        before do
          allow(settings).to receive(:tb_browser_name) { :iexplore }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { is_expected.to be_falsey }
      end
      context 'settings.tb_browser_name is not specified' do
        before { allow(settings).to receive(:tb_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::TbBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
        end
      end
    end
    context 'when testingbot_driver? is FALSE' do
      before { allow(self).to receive(:sauce_driver?) { sauce_driver } }
      context 'when sauce_driver? is TRUE' do
        let(:sauce_driver) { true }
        context 'settings.sl_browser_name = :chrome' do
          before { allow(settings).to receive(:sl_browser_name) { :chrome } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sl_browser_name = :firefox' do
          before { allow(settings).to receive(:sl_browser_name) { :firefox } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sl_browser_name is not specified' do
          before { allow(settings).to receive(:sl_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SlBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
          end
        end
      end
    end
    context 'when selenium_driver? is TRUE' do
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
    context 'when selenium_driver? is FALSE' do
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
      context 'when selenium_driver? is FALSE' do
        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#safari_browser?' do
    subject { safari_browser? }
    before { allow(self).to receive(:sauce_driver?) { sauce_driver } }
    before { allow(self).to receive(:testingbot_driver?) { testingbot_driver } }
    before { allow(self).to receive(:selenium_grid_driver?) { selenium_grid_driver } }
    context 'when sauce_driver? is TRUE' do
      let(:sauce_driver) { true }
      let(:testingbot_driver) { true }
      context 'settings.sl_browser_name = :safari' do
        before { allow(settings).to receive(:sl_browser_name) { :safari } }
        it { is_expected.to be_truthy }
      end
      context 'settings.sl_browser_name = :firefox' do
        before { allow(settings).to receive(:sl_browser_name) { :firefox } }
        it { is_expected.to be_falsey }
      end
      context 'settings.sl_browser_name is not specified' do
        before { allow(settings).to receive(:sl_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::SlBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
        end
      end
    end
    context 'when sauce_driver? is FALSE' do
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
      context 'when selenium_driver? is FALSE' do
        it { is_expected.to be_falsey }
      end
    end
    context 'when testingbot_driver? is TRUE' do
      let(:testingbot_driver) { true }
      before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
      context 'settings.tb_browser_name = :safari' do
        before do
          allow(settings).to receive(:tb_browser_name) { :safari }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { is_expected.to be_truthy }
      end
      context 'settings.tb_browser_name = :iexplore' do
        before do
          allow(settings).to receive(:tb_browser_name) { :iexplore }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { is_expected.to be_falsey }
      end
      context 'settings.tb_browser_name is not specified' do
        before { allow(settings).to receive(:tb_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(
            Howitzer::TbBrowserNotSpecifiedError,
            'Please check your settings'
          ).once.and_call_original
          expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
        end
      end
    end
    context 'when testingbot_driver? is FALSE' do
      before { allow(self).to receive(:sauce_driver?) { sauce_driver } }
      context 'when sauce_driver? is TRUE' do
        let(:sauce_driver) { true }
        context 'settings.sl_browser_name = :safari' do
          before { allow(settings).to receive(:sl_browser_name) { :safari } }
          it { is_expected.to be_truthy }
        end
        context 'settings.sl_browser_name = :firefox' do
          before { allow(settings).to receive(:sl_browser_name) { :firefox } }
          it { is_expected.to be_falsey }
        end
        context 'settings.sl_browser_name is not specified' do
          before { allow(settings).to receive(:sl_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(
              Howitzer::SlBrowserNotSpecifiedError,
              'Please check your settings'
            ).once.and_call_original
            expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
          end
        end
      end
    end
    context 'when selenium_driver? is TRUE' do
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
    context 'when selenium_driver? is FALSE' do
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
      context 'when selenium_driver? is FALSE' do
        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#app_url' do
    subject { app_url }
    before do
      allow(settings).to receive(:app_base_auth_login) { app_base_auth_login_setting }
      allow(settings).to receive(:app_base_auth_pass) { app_base_auth_pass_setting }
      allow(settings).to receive(:app_protocol) { app_protocol_setting }
      allow(settings).to receive(:app_host) { app_host_setting }
    end
    let(:app_protocol_setting) { nil }
    let(:app_host_setting) { 'redmine.strongqa.com' }
    context 'when login and password present' do
      let(:app_base_auth_login_setting) { 'alex' }
      let(:app_base_auth_pass_setting) { 'pa$$w0rd' }
      it { is_expected.to eq('http://alex:pa$$w0rd@redmine.strongqa.com') }
    end
    context 'when login and password blank' do
      let(:app_base_auth_login_setting) { '' }
      let(:app_base_auth_pass_setting) { '' }
      it { is_expected.to eq('http://redmine.strongqa.com') }
    end
  end

  describe '#app_base_url' do
    subject { app_base_url(prefix) }
    before do
      allow(settings).to receive(:app_protocol) { app_protocol_setting }
      allow(settings).to receive(:app_host) { app_host_setting }
    end
    let(:app_protocol_setting) { nil }
    let(:app_host_setting) { 'redmine.strongqa.com' }
    context 'when login and password present' do
      let(:prefix) { 'alex:pa$$w0rd@' }
      it { is_expected.to eq('http://alex:pa$$w0rd@redmine.strongqa.com') }
    end
    context 'when login and password blank' do
      let(:prefix) { nil }
      it { is_expected.to eq('http://redmine.strongqa.com') }
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

  describe '#ri' do
    subject { ri 'boom' }
    it { expect { subject }.to raise_error(RuntimeError, /boom/) }
  end

  describe '#sauce_resource_path' do
    subject { test_object.sauce_resource_path(name) }
    let(:name) { 'test_name' }
    before do
      allow_any_instance_of(SexySettings::Base).to receive(:sl_user) { 'vlad' }
      allow_any_instance_of(SexySettings::Base).to receive(:sl_api_key) { '11111' }
      allow(test_object).to receive(:session_id) { '12341234' }
    end
    it { is_expected.to eql('https://vlad:11111@saucelabs.com/rest/vlad/jobs/12341234/results/test_name') }
  end
  describe '.sauce_resource_path' do
    subject { test_object.sauce_resource_path(name) }
    let(:name) { 'test_name' }
    before do
      allow_any_instance_of(SexySettings::Base).to receive(:sl_user) { 'vlad' }
      allow_any_instance_of(SexySettings::Base).to receive(:sl_api_key) { '11111' }
      allow(test_object).to receive(:session_id) { '12341234' }
    end

    it { is_expected.to eql('https://vlad:11111@saucelabs.com/rest/vlad/jobs/12341234/results/test_name') }
  end

  describe '#update_sauce_job_status' do
    subject { test_object.update_sauce_job_status }
    before  do
      allow_any_instance_of(SexySettings::Base).to receive(:sl_user) { 'vlad1' }
      allow_any_instance_of(SexySettings::Base).to receive(:sl_api_key) { '22222' }
      allow(test_object).to receive(:session_id) { '12341234' }
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

  describe '.update_sauce_resource_path' do
    subject { test_object.update_sauce_job_status }
    before  do
      allow_any_instance_of(SexySettings::Base).to receive(:sl_user) { 'vlad1' }
      allow_any_instance_of(SexySettings::Base).to receive(:sl_api_key) { '22222' }
      allow(test_object).to receive(:session_id) { '12341234' }
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

  describe '#suite_name' do
    subject { test_object.suite_name }
    before do
      allow_any_instance_of(SexySettings::Base).to receive(:sl_browser_name) { 'ie' }
    end

    context 'when environment present' do
      before { ENV['RAKE_TASK'] = rake_task }
      context 'when includes rspec' do
        let(:rake_task) { 'rspec:bvt' }
        it { is_expected.to eql('BVT IE') }
      end
      context 'when includes spec' do
        let(:rake_task) { 'spec:bvt' }
        it { is_expected.to eql('BVT IE') }
      end

      context 'when includes cucumber' do
        let(:rake_task) { 'cucumber:bvt' }
        it { is_expected.to eql('BVT IE') }
      end
      context 'when not includes rpsec and cucumber' do
        let(:rake_task) { 'unknown' }
        it { is_expected.to eql('UNKNOWN IE') }
      end
      context 'when includes only cucumber' do
        let(:rake_task) { 'cucumber' }
        it { is_expected.to eql('ALL IE') }
      end
    end
    context 'when environment empty' do
      before { ENV['RAKE_TASK'] = nil }
      it { is_expected.to eql('CUSTOM IE') }
    end
  end

  describe '.suite_name' do
    subject { test_object.suite_name }
    before do
      allow_any_instance_of(SexySettings::Base).to receive(:sl_browser_name) { 'ie' }
    end

    context 'when environment present' do
      before { ENV['RAKE_TASK'] = rake_task }
      context 'when includes rspec' do
        let(:rake_task) { 'rspec:bvt' }
        it { is_expected.to eql('BVT IE') }
      end
      context 'when includes spec' do
        let(:rake_task) { 'spec:bvt' }
        it { is_expected.to eql('BVT IE') }
      end

      context 'when includes cucumber' do
        let(:rake_task) { 'cucumber:bvt' }
        it { is_expected.to eql('BVT IE') }
      end
      context 'when not includes rpsec and cucumber' do
        let(:rake_task) { 'unknown' }
        it { is_expected.to eql('UNKNOWN IE') }
      end
      context 'when includes only cucumber' do
        let(:rake_task) { 'cucumber' }
        it { is_expected.to eql('ALL IE') }
      end
    end
    context 'when environment empty' do
      before { ENV['RAKE_TASK'] = nil }
      it { is_expected.to eql('CUSTOM IE') }
    end
  end

  describe '#session_id' do
    subject { test_object.session_id }
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

  describe '.session_id' do
    subject { test_object.session_id }
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

  describe '#rake_task_name' do
    subject { test_object.rake_task_name }
    before { ENV['RAKE_TASK'] = rake_task }
    context 'when includes rspec' do
      let(:rake_task) { 'rspec:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes cucumber' do
      let(:rake_task) { 'cucumber:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes spec' do
      let(:rake_task) { 'spec:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes only cucumber' do
      let(:rake_task) { 'cucumber' }
      it { is_expected.to eq('') }
    end
    context 'when includes unknown task' do
      let(:rake_task) { 'unknown' }
      it { is_expected.to eq('UNKNOWN') }
    end
    context 'when environment is empty' do
      let(:rake_task) { nil }
      it { is_expected.to eq('') }
    end
  end

  describe '.rake_task_name' do
    subject { test_object.rake_task_name }
    before { ENV['RAKE_TASK'] = rake_task }
    context 'when includes rspec' do
      let(:rake_task) { 'rspec:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes cucumber' do
      let(:rake_task) { 'cucumber:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes spec' do
      let(:rake_task) { 'spec:bvt' }
      it { is_expected.to eq('BVT') }
    end
    context 'when includes only cucumber' do
      let(:rake_task) { 'cucumber' }
      it { is_expected.to eq('') }
    end
    context 'when includes unknown task' do
      let(:rake_task) { 'unknown' }
      it { is_expected.to eq('UNKNOWN') }
    end
    context 'when environment is empty' do
      let(:rake_task) { nil }
      it { is_expected.to eq('') }
    end
  end
end
