# -*- encoding: utf-8 -*-
require File.expand_path('../lib/howitzer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.author        = 'Roman Parashchenko'
  gem.email         = 'howitzer@strongqa.com'
  gem.description   = 'Howitzer uses the best practices and design patterns allowing to generate a test project in' \
      ' less than 5 minutes. It has out-of-the-box configurations for parallel cross-browser testing in the Cloud.'
  gem.summary       = 'Ruby based framework for acceptance testing'
  gem.homepage      = 'http://strongqa.github.io/howitzer/'
  gem.license       = 'MIT'

  gem.bindir        = 'bin'
  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'howitzer'
  gem.require_paths = ['lib']
  gem.version       = Howitzer::VERSION
  gem.required_ruby_version = '>= 1.9.3'

  gem.add_runtime_dependency 'activesupport', '~>4.2'
  gem.add_runtime_dependency 'addressable', ['>=2.3.3', '< 3.0']
  gem.add_runtime_dependency 'capybara', ['>= 2.1', '< 3.0']
  gem.add_runtime_dependency 'gli'
  gem.add_runtime_dependency 'launchy'
  gem.add_runtime_dependency 'log4r', '~>1.1.10'
  gem.add_runtime_dependency 'nokogiri', '~> 1.6' if gem.platform.to_s =~ /mswin|mingw/
  gem.add_runtime_dependency 'rake'
  gem.add_runtime_dependency 'rspec', '~>3.2'
  gem.add_runtime_dependency 'selenium-webdriver'
  gem.add_runtime_dependency 'sexy_settings'

  gem.add_development_dependency('aruba')
  gem.add_development_dependency('ffaker')
  gem.add_development_dependency('fuubar')
  gem.add_development_dependency('yard')
end
