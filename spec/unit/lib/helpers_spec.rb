require 'spec_helper'
require "howitzer/helpers"

describe "Helpers" do
  let(:settings) { double("settings")}

  describe "#sauce_driver?" do
    subject { sauce_driver? }
    before { allow(settings).to receive(:driver) { driver_setting } }
    context "when :sauce" do
      let(:driver_setting) {:sauce}
      it{ expect(subject).to be_true }
    end
    context "when not :sauce" do
      let(:driver_setting) {:phantomjs}
      it{ expect(subject).to be_false }
    end
    context "when driver specified as String" do
      let(:driver_setting) {"sauce"}
      it{ expect(subject).to be_true }
    end
    context "when driver is not specified" do
      let(:driver_setting) { nil }
      it do
        expect(log).to receive(:error).with(Howitzer::DriverNotSpecifiedError, "Please check your settings").once.and_call_original
        expect { subject }.to raise_error(Howitzer::DriverNotSpecifiedError)
      end
    end
  end

  describe "#testingbot_driver?" do
    subject { testingbot_driver? }
    before { allow(settings).to receive(:driver) { driver_setting } }
    context "when :testingbot" do
      let(:driver_setting) {:testingbot}
      it{ expect(subject).to be_true }
    end
    context "when not :testingbot" do
      let(:driver_setting) {:phantomjs}
      it{ expect(subject).to be_false }
    end
    context "when driver specified as String" do
      let(:driver_setting) {"testingbot"}
      it{ expect(subject).to be_true }
    end
    context "when driver is not specified" do
      let(:driver_setting) { nil }
      it do
        expect(log).to receive(:error).with(Howitzer::DriverNotSpecifiedError, "Please check your settings").once.and_call_original
        expect { subject }.to raise_error(Howitzer::DriverNotSpecifiedError)
      end
    end
  end

  describe "#phantomjs_driver?" do
    subject { phantomjs_driver? }
    before { allow(settings).to receive(:driver) { driver_setting } }
    context "when :phantomjs" do
      let(:driver_setting) {:phantomjs}
      it{ expect(subject).to be_true }
    end
    context "when not :phantomjs" do
      let(:driver_setting) {:selenium}
      it{ expect(subject).to be_false }
    end
    context "when driver specified as String" do
      let(:driver_setting) {"phantomjs"}
      it{ expect(subject).to be_true }
    end
    context "when driver is not specified" do
      let(:driver_setting) { nil }
      it do
        expect(log).to receive(:error).with(Howitzer::DriverNotSpecifiedError, "Please check your settings").once.and_call_original
        expect { subject }.to raise_error(Howitzer::DriverNotSpecifiedError)
      end
    end
  end

  describe "#selenium_driver?" do
    subject { selenium_driver? }
    before { allow(settings).to receive(:driver) { driver_setting } }
    context "when :selenium" do
      let(:driver_setting) {:selenium}
      it{ expect(subject).to be_true }
    end
    context "when not :selenium" do
      let(:driver_setting) {:phantomjs}
      it{ expect(subject).to be_false }
    end
    context "when driver specified as String" do
      let(:driver_setting) {"selenium"}
      it{ expect(subject).to be_true }
    end
    context "when driver is not specified" do
      let(:driver_setting) { nil }
      it do
        expect(log).to receive(:error).with(Howitzer::DriverNotSpecifiedError, "Please check your settings").once.and_call_original
        expect { subject }.to raise_error(Howitzer::DriverNotSpecifiedError)
      end
    end
  end

  describe "#ie_browser?" do
    subject { ie_browser? }
    before { allow(self).to receive(:sauce_driver?) {sauce_driver} }
    before { allow(self).to receive(:testingbot_driver?) {testingbot_driver} }
    context "when sauce_driver? is TRUE" do
      let(:sauce_driver) { true }
      let(:testingbot_driver) { false }
      context "settings.sl_browser_name = :ie" do
        before { allow(settings).to receive(:sl_browser_name) { :ie } }
        it { expect(subject).to be_true }
      end
      context "settings.sl_browser_name = :iexplore" do
        before { allow(settings).to receive(:sl_browser_name) { :iexplore } }
        it { expect(subject).to be_true }
      end
      context "settings.sl_browser_name = :chrome" do
        before { allow(settings).to receive(:sl_browser_name) { :chrome } }
        it { expect(subject).to be_false }
      end
      context "settings.sl_browser_name is not specified" do
        before { allow(settings).to receive(:sl_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(Howitzer::SlBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
          expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
        end
      end
    end
    context "when sauce_driver? is FALSE" do
      let(:sauce_driver) { false }
      let(:testingbot_driver) { false }
      before { allow(self).to receive(:selenium_driver?){ selenium_driver} }
      context "when selenium_driver? is TRUE" do
        let(:selenium_driver) { true }
        context "settings.sel_browser = :ie" do
          before { allow(settings).to receive(:sel_browser) { :ie } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :iexplore" do
          before { allow(settings).to receive(:sel_browser) { :iexplore } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :chrome" do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { expect(subject).to be_false }
        end
        context "settings.sel_browser is not specified" do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::SelBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
      context "when selenium_driver? is FALSE" do
        let(:selenium_driver) { false }
        it { expect(subject).to be_false }
      end
    end
    context "when testingbot_driver? is TRUE" do
      let(:testingbot_driver) { true }
      let(:sauce_driver) { false }
      before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
      context "settings.sel_browser = :ie" do
        before do
          allow(settings).to receive(:tb_browser_name) { :ie }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { expect(subject).to be_true }
      end
      context "settings.tb_browser_name = :iexplore" do
        before do
          allow(settings).to receive(:tb_browser_name) { :iexplore }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { expect(subject).to be_true }
      end
      context "settings.tb_browser_name = :firefox" do
        before do
          allow(settings).to receive(:tb_browser_name) { :firefox }
          allow(settings).to receive(:tb_browser_version) { 8 }
        end
        it { expect(subject).to be_false }
      end
      context "settings.tb_browser_name is not specified" do
        before { allow(settings).to receive(:tb_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(Howitzer::TbBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
          expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
        end
      end
    end
    context "when testingbot_driver? is FALSE" do
      before { allow(self).to receive(:sauce_driver?) { sauce_driver } }
      context "when sauce_driver? is TRUE" do
        let(:testingbot_driver) { false }
        let(:sauce_driver) { true }
        context "settings.sl_browser_name = :ie" do
          before { allow(settings).to receive(:sl_browser_name) { :ie } }
          it { expect(subject).to be_true }
        end
        context "settings.sl_browser_name = :iexplore" do
          before { allow(settings).to receive(:sl_browser_name) { :iexplore } }
          it { expect(subject).to be_true }
        end
        context "settings.sl_browser_name = :chrome" do
          before { allow(settings).to receive(:sl_browser_name) { :chrome } }
          it { expect(subject).to be_false }
        end
        context "settings.sl_browser_name is not specified" do
          before { allow(settings).to receive(:sl_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::SlBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
          end
        end
      end
    end
    context "when selenium_driver? is TRUE" do
      let(:sauce_driver) { false }
      let(:testingbot_driver) { false }
      before { allow(self).to receive(:selenium_driver?) { selenium_driver } }
      context "when selenium_driver? is TRUE" do
        let(:selenium_driver) { true }
        context "settings.sel_browser = :ie" do
          before { allow(settings).to receive(:sel_browser) { :ie } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :iexplore" do
          before { allow(settings).to receive(:sel_browser) { :iexplore } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :chrome" do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { expect(subject).to be_false }
        end
        context "settings.sel_browser is not specified" do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::SelBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
    end
    context "when selenium_driver? is FALSE" do
      before { allow(self).to receive(:selenium_driver?) { false } }
      context "when testingbot_driver? is TRUE" do
        let(:testingbot_driver) { true }
        let(:sauce_driver) { false }
        before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
        context "settings.sl_browser_name = :ie" do
          before do
            allow(settings).to receive(:tb_browser_name) { :ie }
            allow(settings).to receive(:tb_browser_version) { 9 }
          end
          it { expect(subject).to be_true }
        end
        context "settings.tb_browser_name = :iexplore" do
          before do
            allow(settings).to receive(:tb_browser_name) { :iexplore }
            allow(settings).to receive(:tb_browser_version) { 9 }
          end
          it { expect(subject).to be_true }
        end
        context "settings.tb_browser_name = :firefox" do
          before do
            allow(settings).to receive(:tb_browser_name) { :firefox }
            allow(settings).to receive(:tb_browser_version) { 8 }
          end
          it { expect(subject).to be_false }
        end
        context "settings.tb_browser_name is not specified" do
          before { allow(settings).to receive(:tb_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::TbBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
          end
        end
      end
    end
  end
  describe "#ff_browser?" do
    subject { ff_browser? }
    before { allow(self).to receive(:sauce_driver?){ sauce_driver} }
    before { allow(self).to receive(:testingbot_driver?){ testingbot_driver} }
    context "when sauce_driver? is TRUE" do
      let(:sauce_driver) { true }
      let(:testingbot_driver) { false }
      context "settings.sl_browser_name = :ff" do
        before { allow(settings).to receive(:sl_browser_name) { :ff } }
        it { expect(subject).to be_true }
      end
      context "settings.sl_browser_name = :firefox" do
        before { allow(settings).to receive(:sl_browser_name) { :firefox } }
        it { expect(subject).to be_true }
      end
      context "settings.sl_browser_name = :chrome" do
        before { allow(settings).to receive(:sl_browser_name) { :chrome } }
        it { expect(subject).to be_false }
      end
      context "settings.sl_browser_name is not specified" do
        before { allow(settings).to receive(:sl_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(Howitzer::SlBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
          expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
        end
      end
    end
    context "when sauce_driver? is FALSE" do
      let(:testingbot_driver) { false }
      let(:sauce_driver) { false }
      before { allow(self).to receive(:selenium_driver?){ selenium_driver} }
      context "when selenium_driver? is TRUE" do
        let(:selenium_driver) { true }
        context "settings.sel_browser = :ff" do
          before { allow(settings).to receive(:sel_browser) { :ff } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :firefox" do
          before { allow(settings).to receive(:sel_browser) { :firefox } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :chrome" do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { expect(subject).to be_false }
        end
        context "settings.sel_browser is not specified" do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::SelBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
      context "when selenium_driver? is FALSE" do
        let(:selenium_driver) { false }
        it { expect(subject).to be_false }
      end
    end
    context "when testingbot_driver? is TRUE" do
      let(:testingbot_driver) { true }
      let(:sauce_driver) { false }
      before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
      context "settings.tb_browser_name = :ff" do
        before do
          allow(settings).to receive(:tb_browser_name) { :ff }
          allow(settings).to receive(:tb_browser_version) { 8 }
        end
        it { expect(subject).to be_true }
      end
      context "settings.tb_browser_name = :firefox" do
        before do
          allow(settings).to receive(:tb_browser_name) { :firefox }
          allow(settings).to receive(:tb_browser_version) { 8 }
        end
        it { expect(subject).to be_true }
      end
      context "settings.tb_browser_name = :iexplore" do
        before do
          allow(settings).to receive(:tb_browser_name) { :iexplore }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { expect(subject).to be_false }
      end
      context "settings.tb_browser_name is not specified" do
        before { allow(settings).to receive(:tb_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(Howitzer::TbBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
          expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
        end
      end
    end
    context "when testingbot_driver? is FALSE" do
      before { allow(self).to receive(:sauce_driver?) { sauce_driver } }
      context "when sauce_driver? is TRUE" do
        let(:testingbot_driver) { false }
        let(:sauce_driver) { true }
        context "settings.sl_browser_name = :ff" do
          before { allow(settings).to receive(:sl_browser_name) { :ff } }
          it { expect(subject).to be_true }
        end
        context "settings.sl_browser_name = :firefox" do
          before { allow(settings).to receive(:sl_browser_name) { :firefox } }
          it { expect(subject).to be_true }
        end
        context "settings.sl_browser_name = :chrome" do
          before { allow(settings).to receive(:sl_browser_name) { :chrome } }
          it { expect(subject).to be_false }
        end
        context "settings.sl_browser_name is not specified" do
          before { allow(settings).to receive(:sl_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::SlBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
          end
        end
      end
    end
    context "when selenium_driver? is TRUE" do
      let(:sauce_driver) { false }
      let(:testingbot_driver) { false }
      before { allow(self).to receive(:selenium_driver?) { selenium_driver } }
      context "when selenium_driver? is TRUE" do
        let(:selenium_driver) { true }
        context "settings.sel_browser = :ff" do
          before { allow(settings).to receive(:sel_browser) { :ff } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :firefox" do
          before { allow(settings).to receive(:sel_browser) { :firefox } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :chrome" do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { expect(subject).to be_false }
        end
        context "settings.sel_browser is not specified" do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::SelBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
    end
    context "when selenium_driver? is FALSE" do
      before { allow(self).to receive(:selenium_driver?) { false } }
      context "when testingbot_driver? is TRUE" do
        let(:testingbot_driver) { true }
        let(:sauce_driver) { false }
        before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
        context "settings.tb_browser_name = :firefox" do
          before do
            allow(settings).to receive(:tb_browser_name) { :firefox }
            allow(settings).to receive(:tb_browser_version) { 8 }
          end
          it { expect(subject).to be_true }
        end
        context "settings.tb_browser_name = :ff" do
          before do
            allow(settings).to receive(:tb_browser_name) { :ff }
            allow(settings).to receive(:tb_browser_version) { 8 }
          end
          it { expect(subject).to be_true }
        end
        context "settings.tb_browser_name = :iexplore" do
          before do
            allow(settings).to receive(:tb_browser_name) { :iexplore }
            allow(settings).to receive(:tb_browser_version) { 9 }
          end
          it { expect(subject).to be_false }
        end
        context "settings.tb_browser_name is not specified" do
          before { allow(settings).to receive(:tb_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::TbBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
          end
        end
      end

    end
  end
  describe "#chrome_browser?" do
    subject { chrome_browser? }
    before { allow(self).to receive(:sauce_driver?){ sauce_driver} }
    before { allow(self).to receive(:testingbot_driver?){ testingbot_driver} }
    context "when sauce_driver? is TRUE" do
      let(:sauce_driver) { true }
      let(:testingbot_driver) { true }
      context "settings.sl_browser_name = :chrome" do
        before { allow(settings).to receive(:sl_browser_name) { :chrome } }
        it { expect(subject).to be_true }
      end
      context "settings.sl_browser_name = :firefox" do
        before { allow(settings).to receive(:sl_browser_name) { :firefox } }
        it { expect(subject).to be_false }
      end
      context "settings.sl_browser_name is not specified" do
        before { allow(settings).to receive(:sl_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(Howitzer::SlBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
          expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
        end
      end
    end
    context "when sauce_driver? is FALSE" do
      let(:sauce_driver) { false }
      let(:testingbot_driver) { false }
      before { allow(self).to receive(:selenium_driver?){ selenium_driver} }
      context "when selenium_driver? is TRUE" do
        let(:selenium_driver) { true }
        context "settings.sel_browser = :chrome" do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :firefox" do
          before { allow(settings).to receive(:sel_browser) { :firefox } }
          it { expect(subject).to be_false }
        end
        context "settings.sel_browser is not specified" do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::SelBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
      context "when selenium_driver? is FALSE" do
        let(:selenium_driver) { false }
        it { expect(subject).to be_false }
      end
    end
    context "when testingbot_driver? is TRUE" do
      let(:testingbot_driver) { true }
      let(:sauce_driver) { false }
      before { allow(settings).to receive(:testingbot_driver?) { testingbot_driver } }
      context "settings.tb_browser_name = :chrome" do
        before do
          allow(settings).to receive(:tb_browser_name) { :chrome }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { expect(subject).to be_true }
      end
      context "settings.tb_browser_name = :iexplore" do
        before do
          allow(settings).to receive(:tb_browser_name) { :iexplore }
          allow(settings).to receive(:tb_browser_version) { 9 }
        end
        it { expect(subject).to be_false }
      end
      context "settings.tb_browser_name is not specified" do
        before { allow(settings).to receive(:tb_browser_name) { nil } }
        it do
          expect(log).to receive(:error).with(Howitzer::TbBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
          expect { subject }.to raise_error(Howitzer::TbBrowserNotSpecifiedError)
        end
      end
    end
    context "when testingbot_driver? is FALSE" do
      before { allow(self).to receive(:sauce_driver?) { sauce_driver } }
      context "when sauce_driver? is TRUE" do
        let(:testingbot_driver) { false }
        let(:sauce_driver) { true }
        context "settings.sl_browser_name = :chrome" do
          before { allow(settings).to receive(:sl_browser_name) { :chrome } }
          it { expect(subject).to be_true }
        end
        context "settings.sl_browser_name = :firefox" do
          before { allow(settings).to receive(:sl_browser_name) { :firefox } }
          it { expect(subject).to be_false }
        end
        context "settings.sl_browser_name is not specified" do
          before { allow(settings).to receive(:sl_browser_name) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::SlBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::SlBrowserNotSpecifiedError)
          end
        end
      end

    end
    context "when selenium_driver? is TRUE" do
      let(:sauce_driver) { false }
      let(:testingbot_driver) { false }
      before { allow(self).to receive(:selenium_driver?) { selenium_driver } }
      context "when selenium_driver? is TRUE" do
        let(:selenium_driver) { true }
        context "settings.sel_browser = :chrome" do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :firefox" do
          before { allow(settings).to receive(:sel_browser) { :firefox } }
          it { expect(subject).to be_false }
        end
        context "settings.sel_browser is not specified" do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::SelBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end

    end
    context "when selenium_driver? is FALSE" do
      let(:sauce_driver) { false }
      let(:testingbot_driver) { false }
      before { allow(self).to receive(:selenium_driver?){ selenium_driver} }
      context "when selenium_driver? is TRUE" do
        let(:selenium_driver) { true }
        context "settings.sel_browser = :chrome" do
          before { allow(settings).to receive(:sel_browser) { :chrome } }
          it { expect(subject).to be_true }
        end
        context "settings.sel_browser = :firefox" do
          before { allow(settings).to receive(:sel_browser) { :firefox } }
          it { expect(subject).to be_false }
        end
        context "settings.sel_browser is not specified" do
          before { allow(settings).to receive(:sel_browser) { nil } }
          it do
            expect(log).to receive(:error).with(Howitzer::SelBrowserNotSpecifiedError, "Please check your settings").once.and_call_original
            expect { subject }.to raise_error(Howitzer::SelBrowserNotSpecifiedError)
          end
        end
      end
      context "when selenium_driver? is FALSE" do
        let(:selenium_driver) { false }
        it { expect(subject).to be_false }
      end
    end
  end
  describe "#app_url" do
    subject { app_url }
    before do
      allow(settings).to receive(:app_base_auth_login) { app_base_auth_login_setting }
      allow(settings).to receive(:app_base_auth_pass) { app_base_auth_pass_setting }
      allow(settings).to receive(:app_protocol) { app_protocol_setting }
      allow(settings).to receive(:app_host) { app_host_setting }
    end
    let(:app_protocol_setting) { nil }
    let(:app_host_setting) { "redmine.strongqa.com" }
    context "when login and password present" do
      let(:app_base_auth_login_setting) { "alex" }
      let(:app_base_auth_pass_setting) { "pa$$w0rd" }
      it{ expect(subject).to eq("http://alex:pa$$w0rd@redmine.strongqa.com") }
    end
    context "when login and password blank" do
      let(:app_base_auth_login_setting) { "" }
      let(:app_base_auth_pass_setting) { "" }
      it{ expect(subject).to eq("http://redmine.strongqa.com") }
    end
  end
  describe "#app_base_url" do
    subject { app_base_url(prefix) }
    before do
      allow(settings).to receive(:app_protocol) { app_protocol_setting }
      allow(settings).to receive(:app_host) { app_host_setting }
    end
    let(:app_protocol_setting) { nil }
    let(:app_host_setting) { "redmine.strongqa.com" }
    context "when login and password present" do
      let(:prefix) { "alex:pa$$w0rd@" }
      it{ expect(subject).to eq("http://alex:pa$$w0rd@redmine.strongqa.com") }
    end
    context "when login and password blank" do
      let(:prefix) { nil }
      it{ expect(subject).to eq("http://redmine.strongqa.com") }
    end
  end
  describe "#duration" do
    context "when more than hour" do
      it{ expect(duration(10000)).to eq("[2h 46m 40s]") }
    end
    context "when 1 hour exactly" do
      it{ expect(duration(3600)).to eq("[1h 0m 0s]") }
    end
    context "when 0 hours and more than minute" do
      it{ expect(duration(2000)).to eq("[33m 20s]") }
    end
    context "when 1 minute exactly" do
      it{ expect(duration(60)).to eq("[1m 0s]") }
    end
    context "when less than minute" do
      it{ expect(duration(45)).to eq("[0m 45s]") }
    end
    context "when zero" do
      it{ expect(duration(0)).to eq("[0m 0s]") }
    end
  end
  describe "#ri" do
    subject { ri 'boom' }
    it { expect {subject}.to raise_error(RuntimeError, /boom/) }
  end
  describe String do
    let(:page_name) { "my" }
    let(:page_object) { double }
    before { stub_const("MyPage", page_object) }
    describe "#open" do
      subject { page_name.open(:exit) }
      before do
        expect(page_object).to receive(:open).with(:exit).once
      end
      it { expect(subject).to be_nil }
    end
    describe "#given" do
      subject { page_name.given }
      before do
        allow(page_name).to receive(:as_page_class){ page_object }
        expect(page_object).to receive(:given).once
      end
      it { expect(subject).to be_nil }
    end
    describe "#wait_for_opened" do
      subject { page_name.wait_for_opened }
      before do
        allow(page_name).to receive(:as_page_class){ page_object }
        expect(page_object).to receive(:wait_for_opened).once
      end
      it { expect(subject).to be_nil }
    end
    describe "#as_page_class" do
      subject { page_name.as_page_class }
      context "when 1 word" do
        it { expect(subject).to eql(page_object) }
      end
      context "when more 1 word" do
        let(:page_name) { 'my  super mega' }
        before { stub_const("MySuperMegaPage", page_object) }
        it { expect(subject).to eql(page_object) }
      end

      context "when plural word" do
        let(:page_name) { 'user notifications' }
        before { stub_const("UserNotificationsPage", page_object) }
        it { expect(subject).to eql(page_object) }
      end
    end
    describe "#as_email_class" do
      subject { email_name.as_email_class }
      let(:my_email) { double }
      context "when 1 word" do
        let(:email_name) { 'my' }
        before { stub_const("MyEmail", my_email) }
        it { expect(subject).to eql(my_email) }
      end

      context "when more 1 word" do
        let(:email_name) { 'my  super mega' }
        before { stub_const("MySuperMegaEmail", my_email) }
        it { expect(subject).to eql(my_email) }
      end

      context "when plural word" do
        let(:email_name) { 'email notifications' }
        before { stub_const("EmailNotificationsEmail", my_email) }
        it { expect(subject).to eql(my_email) }
      end
    end
  end
end
