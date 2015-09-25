Given /^created old howitzer project based on rspec$/ do
  run_simple 'howitzer new test_automation --rspec'
  FileUtils.move(Dir.glob("#{expand_path(".")}/test_automation/*"), expand_path("."))
  FileUtils.remove_dir File.join(expand_path("."), 'test_automation'), true
  overwrite_file('boot.rb', "Dir.chdir(File.join(File.dirname(__FILE__), '.'))")
  overwrite_file('Gemfile', "Hello")
  remove 'config/default.yml'
end

Given /^created old howitzer project based on cucumber$/ do
  run_simple 'howitzer new test_automation --cucumber'
  FileUtils.move(Dir.glob("#{expand_path(".")}/test_automation/*"), expand_path("."))
  FileUtils.remove_dir File.join(expand_path("."), 'test_automation'), true
  overwrite_file('boot.rb', "Dir.chdir(File.join(File.dirname(__FILE__), '.'))")
  overwrite_file('Gemfile', "Hello")
  remove 'config/default.yml'
end

Given /^created old howitzer project based on turnip$/ do
  run_simple 'howitzer new test_automation --turnip'
  FileUtils.move(Dir.glob("#{expand_path(".")}/test_automation/*"), expand_path("."))
  FileUtils.remove_dir File.join(expand_path("."), 'test_automation'), true
end