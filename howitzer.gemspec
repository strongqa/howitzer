require File.expand_path('lib/howitzer/version', __dir__)

Gem::Specification.new do |gem|
  gem.author        = 'Roman Parashchenko'
  gem.email         = 'howitzer@strongqa.com'
  gem.description   = 'Howitzer uses the best practices and design patterns allowing to generate a test project in ' \
                      'less than 5 minutes. It has out-of-the-box configurations for parallel cross-browser testing ' \
                      'in the cloud.'
  gem.summary       = 'Ruby based framework for acceptance testing'
  gem.homepage      = 'https://howitzer-framework.io/'
  gem.metadata = {
    'bug_tracker_uri' => 'https://github.com/strongqa/howitzer/issues',
    'changelog_uri' => 'https://github.com/strongqa/howitzer/blob/master/CHANGELOG.md',
    'documentation_uri' => "https://www.rubydoc.info/gems/howitzer/#{Howitzer::VERSION}",
    'source_code_uri' => 'https://github.com/strongqa/howitzer',
    'rubygems_mfa_required' => 'true'
  }
  gem.license = 'MIT'
  gem.files = Dir[
    'CHANGELOG.md',
    'CONTRIBUTING.md',
    'README.md',
    'LICENSE',
    'generators/**/*',
    'lib/**/*',
    '.yardopts'
  ]
  gem.executables   = ['howitzer']
  gem.name          = 'howitzer'
  gem.require_path  = 'lib'
  gem.version       = Howitzer::VERSION
  gem.required_ruby_version = '>= 2.6.8'

  gem.add_runtime_dependency 'activesupport', ['>= 5', '< 7']
  gem.add_runtime_dependency 'capybara', '< 4.0'
  gem.add_runtime_dependency 'colorize'
  gem.add_runtime_dependency 'gli'
  gem.add_runtime_dependency 'launchy'
  gem.add_runtime_dependency 'log4r', '~>1.1.10'
  gem.add_runtime_dependency 'nokogiri', '~> 1.6' if gem.platform.to_s =~ /mswin|mingw/
  gem.add_runtime_dependency 'rake'
  gem.add_runtime_dependency 'rspec', '~>3.2'
  gem.add_runtime_dependency 'rspec-wait'
  gem.add_runtime_dependency 'selenium-webdriver', ['>= 3.4.1', '< 5.0']
  gem.add_runtime_dependency 'sexy_settings'

  gem.add_development_dependency('aruba')
  gem.add_development_dependency('ffaker')
  gem.add_development_dependency('fuubar')
  gem.add_development_dependency('yard')
end
