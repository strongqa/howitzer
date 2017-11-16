Given /^created old howitzer project based on rspec$/ do
  run_simple 'howitzer new test_automation --rspec'
  all_commands.shift

  FileUtils.move(Dir.glob("#{expand_path('.')}/test_automation/*"), expand_path('.'))
  FileUtils.remove_dir File.join(expand_path('.'), 'test_automation'), true
  overwrite_file('Rakefile', "Dir.chdir(File.join(__dir__, '.'))")
  overwrite_file('Gemfile', 'Hello')
  remove 'config/default.yml'
end

Given /^created old howitzer project based on cucumber$/ do
  run_simple 'howitzer new test_automation --cucumber'
  all_commands.shift

  FileUtils.move(Dir.glob("#{expand_path('.')}/test_automation/*"), expand_path('.'))
  FileUtils.remove_dir File.join(expand_path('.'), 'test_automation'), true
  overwrite_file('Rakefile', "Dir.chdir(File.join(__dir__, '.'))")
  overwrite_file('Gemfile', 'Hello')
  remove 'config/default.yml'
end

Given /^created old howitzer project based on turnip$/ do
  run_simple 'howitzer new test_automation --turnip'
  all_commands.shift

  FileUtils.move(Dir.glob("#{expand_path('.')}/test_automation/*"), expand_path('.'))
  FileUtils.remove_dir File.join(expand_path('.'), 'test_automation'), true
end

Then 'the output should be exactly:' do |text|
  text.gsub!('<HOWITZER_VERSION>', Howitzer::VERSION)
  step 'the output should contain exactly:', text
end
