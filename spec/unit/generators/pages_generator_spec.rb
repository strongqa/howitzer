require 'spec_helper'

RSpec.describe 'Generators' do
  let(:destination) { Howitzer::BaseGenerator.destination }
  let(:output) { StringIO.new }
  subject { file_tree_info(destination) }
  before do
    Howitzer::BaseGenerator.logger = output
    generator_name.new
  end
  after { FileUtils.rm_r(destination) }

  describe 'PagesGenerator' do
    let(:generator_name) { Howitzer::PagesGenerator }
    let(:expected_result) do
      [
          {:name=> '/pages', :is_directory=>true},
          {:name=> '/pages/example_menu.rb', :is_directory=>false, :size=>template_file_size('pages', 'example_menu.rb')},
          {:name=> '/pages/example_page.rb', :is_directory=>false, :size=>template_file_size('pages', 'example_page.rb')}
      ]
    end
    it { is_expected.to eql(expected_result) }
    describe 'output' do
      let(:expected_output) do
        "  * PageOriented pattern structure generation ...
      Added 'pages/example_page.rb' file
      Added 'pages/example_menu.rb' file\n"
      end
      subject { output.string }
      it { is_expected.to eql(expected_output) }
    end
  end
end