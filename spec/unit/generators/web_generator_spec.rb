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

  describe Howitzer::WebGenerator do
    let(:generator_name) { described_class }
    let(:expected_result) do
      [
        {
          name: '/web',
          is_directory: true
        },
        {
          name: '/web/pages',
          is_directory: true
        },
        {
          name: '/web/pages/example_page.rb',
          is_directory: false,
          size: template_file_size('web', 'example_page.rb')
        },
        {
          name: '/web/sections',
          is_directory: true
        },
        {
          name: '/web/sections/menu_section.rb',
          is_directory: false,
          size: template_file_size('web', 'menu_section.rb')
        }
      ]
    end
    it { is_expected.to eql(expected_result) }
    describe 'output' do
      let(:expected_output) do
        "#{'  * PageOriented pattern structure generation ...'.colorize(:light_cyan)}
      #{'Added'.colorize(:light_green)} 'web/pages/example_page.rb' file
      #{'Added'.colorize(:light_green)} 'web/sections/menu_section.rb' file\n"
      end
      subject { output.string }
      it { is_expected.to eql(expected_output) }
    end
  end
end
