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
        { name: '/config/drivers/browserstack_driver.rb', is_directory: false, size: 914 },
        { name: '/config/drivers/crossbrowsertesting_driver.rb', is_directory: false, size: 1131 },
        { name: '/config/drivers/headless_chrome_driver.rb', is_directory: false, size: 696 },
        { name: '/config/drivers/phantomjs_driver.rb', is_directory: false, size: 636 },
        { name: '/config/drivers/poltergeist_driver.rb', is_directory: false, size: 443 },
        { name: '/config/drivers/sauce_driver.rb', is_directory: false, size: 871 },
        { name: '/config/drivers/selenium_driver.rb', is_directory: false, size: 1097 },
        { name: '/config/drivers/selenium_grid_driver.rb', is_directory: false, size: 1271 },
        { name: '/config/drivers/testingbot_driver.rb', is_directory: false, size: 804 },
        { name: '/config/drivers/webkit_driver.rb', is_directory: false, size: 285 }
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
      #{ColorizedString.new('Added').light_green} 'config/drivers/browserstack_driver.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/crossbrowsertesting_driver.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/headless_chrome_driver.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/phantomjs_driver.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/poltergeist_driver.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/sauce_driver.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/selenium_driver.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/selenium_grid_driver.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/testingbot_driver.rb' file
      #{ColorizedString.new('Added').light_green} 'config/drivers/webkit_driver.rb' file\n"
      end
      subject { output.string }
      it { is_expected.to eql(expected_output) }
    end
  end
end
