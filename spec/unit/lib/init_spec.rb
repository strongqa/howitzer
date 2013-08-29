require 'spec_helper'
require "#{lib_path}/howitzer/utils/data_generator/gen.rb"
require 'capybara/dsl'

describe "Helpers" do
  before do
    stub_const("Mailgun", double)
    expect(settings).to receive(:mailgun_api_key){ 'some_api' }
  end
  it "should init Mailgun and include modules" do
    expect(Mailgun).to receive(:init).with('some_api').once
    require "#{lib_path}/howitzer/init.rb"
  end
end