require 'spec_helper'

describe "Root libraries" do
  before { allow(self).to receive(:require) { true }}
  it "should be loaded in right order" do
    pending("Should be fixed")
    expect(self).to receive(:require).with("howitzer/version").once.ordered
    expect(self).to receive(:require).with("howitzer/settings").once.ordered
    expect(self).to receive(:require).with('howitzer/utils').once.ordered
    expect(self).to receive(:require).with('howitzer/init').once.ordered
    expect(self).to receive(:require).with('howitzer/helpers').once.ordered
    expect(self).to receive(:require).with('howitzer/web_page').once.ordered
    load "lib/howitzer.rb"
  end
end