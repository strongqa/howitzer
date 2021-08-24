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

  describe Howitzer::ConfigGenerator do
    let(:generator_name) { described_class }
    let(:expected_result) do
      [
        { name: '/config', is_directory: true },
        { name: '/config/boot.rb', is_directory: false, size: template_file_size('config', 'boot.rb') },
        { name: '/config/capybara.rb', is_directory: false, size: template_file_size('config', 'capybara.rb') },
        { name: '/config/custom.yml', is_directory: false, size: template_file_size('config', 'custom.yml') },
        { name: '/config/default.yml', is_directory: false, size: template_file_size('config', 'default.yml') },
        { name: '/config/drivers', is_directory: true },
        { name: '/config/drivers/appium.rb', is_directory: false, size: 723 },
        { name: '/config/drivers/browserstack.rb', is_directory: false, size: 1018 },
        { name: '/config/drivers/crossbrowsertesting.rb', is_directory: false, size: 1237 },
        { name: '/config/drivers/headless_chrome.rb', is_directory: false, size: 649 },
        { name: '/config/drivers/headless_firefox.rb', is_directory: false, size: 1059 },
        { name: '/config/drivers/poltergeist.rb', is_directory: false, size: 362 },
        { name: '/config/drivers/sauce.rb', is_directory: false, size: 968 },
        { name: '/config/drivers/selenium.rb', is_directory: false, size: 1097 },
        { name: '/config/drivers/selenium_grid.rb', is_directory: false, size: 1431 },
        { name: '/config/drivers/testingbot.rb', is_directory: false, size: 906 }
      ]
    end

    it { is_expected.to eql(expected_result) }
    describe 'output' do
      let(:expected_output) do
        "#{ColorizedString.new('  * Config files generation ...').light_cyan}
      #{ColorizedString.new('Added').light_green} 'config/boot.rb' file
      #{ColorizedString.new('Added').light_green} 'config/custom.yml' file
      #{ColorizedString.new('Added').light_green} 'config/capybara.rb' file
      #{ColorizedString.new('Added').light_green} 'config/default.yml' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/appium.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/browserstack.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/crossbrowsertesting.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/headless_chrome.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/headless_firefox.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/poltergeist.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/sauce.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/selenium.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/selenium_grid.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/testingbot.rb' file\n"
      end
      subject { output.string }
      it { is_expected.to eql(expected_output) }
    end
  end
end
