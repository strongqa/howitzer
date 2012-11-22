# -*- encoding: utf-8 -*-
require File.expand_path('../lib/howitzer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Roman Parashchenko, Konstantin Lynda, Nikolay Zozulyak"]
  gem.email         = ["strongqa@gmail.com"]
  gem.description   = %q{The framework is based on Page Object pattern, Capybara and Rspec/Cucumber libraries}
  gem.summary       = %q{Universal Ruby Test Framework for black box testing}
  gem.homepage      = "https://github.com/romikoops/howitzer"

  gem.bindir        = 'bin'
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "howitzer"
  gem.require_paths = ["lib"]
  gem.version       = Howitzer::VERSION
  gem.required_ruby_version = '~> 1.9.2'

  gem.add_runtime_dependency 'rake'
  gem.add_runtime_dependency 'rubigen'
  gem.add_runtime_dependency 'i18n'
  gem.add_runtime_dependency 'cucumber'
  gem.add_runtime_dependency 'rspec', '~> 2.0'
  gem.add_runtime_dependency 'sexy_settings'
  gem.add_runtime_dependency 'repeater'
  gem.add_runtime_dependency 'selenium-webdriver'
  gem.add_runtime_dependency 'capybara'
  gem.add_runtime_dependency 'launchy'
  gem.add_runtime_dependency 'log4r'
  gem.add_runtime_dependency 'mail'
  gem.add_runtime_dependency 'rest-client'
  gem.add_runtime_dependency 'poltergeist'
  gem.add_runtime_dependency 'activeresource', '< 3.2.0', '>= 2.3.5'
end
