# -*- encoding: utf-8 -*-
require File.expand_path('../lib/howitzer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["SirNicholas"]
  gem.email         = ["zozulyak.nick@gmail.com"]
  gem.description   = %q{Universal Ruby Test Framework}
  gem.summary       = %q{Test Framework generator}
  gem.homepage      = ""

  gem.bindir        = 'bin'
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "howitzer"
  gem.require_paths = ["lib"]
  gem.version       = Howitzer::VERSION
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rubigen'
  gem.add_development_dependency 'i18n'
  gem.add_development_dependency 'newgem'
end
