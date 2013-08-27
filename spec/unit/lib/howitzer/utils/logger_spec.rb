#require 'spec_helper'
#require_relative '../../../../../lib/howitzer/utils/logger'
#
#describe "Logger" do
#  context "#log" do
#    subject { log }
#    let(:other_log) { log }
#    it { expect(subject).to be_a_kind_of(Log4r::Logger) }
#    it { expect(subject).to equal(other_log) }
#  end
#
#  context "#print_feature_name" do
#    subject { log.print_feature_name(text) }
#    let(:text) { 'Some feature' }
#    let(:destination) { Dir.mktmpdir }
#    let(:filename) { 'log1.txt' }
#    before do
#      @logger = Logger.new("ruby_log")
#      #FileUtils.mkdir_p(destination)
#      FileUtils.mkdir_p(settings.log_dir) unless File.exists?(settings.log_dir)
#
#      filename = File.join(settings.log_dir, settings.txt_log)
#
#      txt_log = FileOutputter.new(:txt_log, :filename => filename, :trunc => true)
#
#      @logger.add(txt_log)
#    end
#    it { subject }
#  end
#end