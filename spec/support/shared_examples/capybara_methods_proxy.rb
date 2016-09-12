require 'spec_helper'

RSpec.shared_examples :capybara_methods_proxy do
  let(:session) { double(:session) }
  before do
    allow(Capybara).to receive(:current_session) { session }
    allow(Howitzer).to receive(:driver) { driver_name }
    allow(session).to receive(:current_url) { 'google.com' }
  end

  describe '#driver' do
    it 'should proxy #driver method' do
      expect(session).to receive(:driver).once
      reciever.driver
    end
  end

  describe '#text' do
    it 'should proxy #text method' do
      expect(session).to receive(:text).once
      reciever.text
    end
  end

  context 'when capybara session method' do
    it 'should proxy method' do
      expect(session).to receive(:visit).once
      reciever.visit
    end
  end

  context 'when capybara modal method' do
    it 'should proxy method' do
      expect(session).to receive(:dismiss_prompt).with(:some_text).once
      reciever.dismiss_prompt(:some_text)
    end
  end

  describe '#click_alert_box' do
    subject { reciever.click_alert_box(flag_value) }
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
end
