require 'spec_helper'

RSpec.describe 'Generators' do
  let(:destination) { Howitzer::BaseGenerator.destination }
  let(:output) { StringIO.new }
  subject { file_tree_info(destination) }
  before do
    Howitzer::BaseGenerator.logger = output
    generator_name.new({})
  end
  after { FileUtils.rm_r(destination) }

  describe Howitzer::PrerequisitesGenerator do
    let(:generator_name) { described_class }
    let(:expected_result) do
      [
        { name: '/prerequisites', is_directory: true },
        { name: '/prerequisites/factories', is_directory: true },
        {
          name: '/prerequisites/factories/users.rb',
          is_directory: false, size: template_file_size('prerequisites', 'users.rb')
        },
        {
          name: '/prerequisites/factory_girl.rb',
          is_directory: false, size: template_file_size('prerequisites', 'factory_girl.rb')
        },
        { name: '/prerequisites/models', is_directory: true },
        {
          name: '/prerequisites/models/base.rb',
          is_directory: false,
          size: template_file_size('prerequisites', 'base.rb')
        },
        {
          name: '/prerequisites/models/user.rb',
          is_directory: false,
          size: template_file_size('prerequisites', 'user.rb')
        }
      ]
    end
    it { is_expected.to eql(expected_result) }
    describe 'output' do
      let(:expected_output) do
        "  * Pre-requisites integration to the framework ...
      Added 'prerequisites/factory_girl.rb' file
      Added 'prerequisites/factories/users.rb' file
      Added 'prerequisites/models/base.rb' file
      Added 'prerequisites/models/user.rb' file\n"
      end
      subject { output.string }
      it { is_expected.to eql(expected_output) }
    end
  end
end
