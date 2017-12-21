require 'spec_helper'
require 'howitzer/utils/string_extensions'

RSpec.describe Howitzer::Utils::StringExtensions do
  String.send(:include, Howitzer::Utils::StringExtensions)

  let(:page_name) { 'my' }
  let(:page_object) { double }
  before { stub_const('MyPage', page_object) }
  describe '#open' do
    subject { page_name.open(:exit) }
    before do
      expect(page_object).to receive(:open).with(:exit).once
    end
    it { is_expected.to be_nil }
  end
  describe '#given' do
    subject { page_name.given }
    before do
      allow(page_name).to receive(:as_page_class) { page_object }
      expect(page_object).to receive(:given).once
    end
    it { is_expected.to be_nil }
  end
  describe '#displayed?' do
    subject { page_name.displayed? }
    before do
      allow(page_name).to receive(:as_page_class) { page_object }
      expect(page_object).to receive(:displayed?).once
    end
    it { is_expected.to be_nil }
  end
  describe '#as_page_class' do
    subject { page_name.as_page_class }
    context 'when 1 word' do
      it { is_expected.to eql(page_object) }
    end
    context 'when more 1 word' do
      let(:page_name) { 'my  super mega' }
      before { stub_const('MySuperMegaPage', page_object) }
      it { is_expected.to eql(page_object) }
    end
    context 'when plural word' do
      let(:page_name) { 'user notifications' }
      before { stub_const('UserNotificationsPage', page_object) }
      it { is_expected.to eql(page_object) }
    end
  end
  describe '#as_email_class' do
    subject { email_name.as_email_class }
    let(:my_email) { double }
    context 'when 1 word' do
      let(:email_name) { 'my' }
      before { stub_const('MyEmail', my_email) }
      it { is_expected.to eql(my_email) }
    end
    context 'when more 1 word' do
      let(:email_name) { 'my  super mega' }
      before { stub_const('MySuperMegaEmail', my_email) }
      it { is_expected.to eql(my_email) }
    end
    context 'when plural word' do
      let(:email_name) { 'email notifications' }
      before { stub_const('EmailNotificationsEmail', my_email) }
      it { is_expected.to eql(my_email) }
    end
  end
  describe '#on' do
    let(:block) { ->{} }
    subject { page_name.on(&block) }
    before do
      allow(page_name).to receive(:as_page_class) { page_object }
      expect(page_object).to receive(:on).once
    end
    it { is_expected.to be_nil }
  end
end
