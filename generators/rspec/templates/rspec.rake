require 'rspec/core/rake_task'
RSPEC_OPTS = "--format html --out ./#{settings.log_dir}/#{settings.html_log} --format documentation --color"

RSpec::Core::RakeTask.new(:rspec, 'Run all rspec scenarios') do |t|
  t.rspec_opts = RSPEC_OPTS
end

RSpec::Core::RakeTask.new(:features, 'Run all workable scenarios (without @wip and @bug tags)') do |t|
  t.rspec_opts = "#{RSPEC_OPTS} --tag ~wip --tag ~bug"
end

namespace :features do
  RSpec::Core::RakeTask.new(:wip, 'Run scenarios in progress (with @wip tag)') do |t|
    t.rspec_opts = "#{RSPEC_OPTS} --tag wip"
  end

  RSpec::Core::RakeTask.new(:bug, 'Run scenarios with known bugs (with @bug tag)') do |t|
    t.rspec_opts = "#{RSPEC_OPTS} --tag bug"
  end

  RSpec::Core::RakeTask.new(:smoke, 'Run workable smoke scenarios (with @smoke tag)') do |t|
    t.rspec_opts = "#{RSPEC_OPTS} --tag smoke --tag ~wip --tag ~bug"
  end

  RSpec::Core::RakeTask.new(:bvt, 'Run workable build verification test scenarios') do |t|
    t.rspec_opts = "#{RSPEC_OPTS} --tag ~wip --tag ~bug --tag ~p1 --tag ~p2 --tag ~smoke"
  end

  RSpec::Core::RakeTask.new(:p1, 'Run workable scenarios with normal priority (with @p1 tag)') do |t|
    t.rspec_opts = "#{RSPEC_OPTS} --tag p1 --tag ~wip --tag ~bug"
  end

  RSpec::Core::RakeTask.new(:p2, 'Run workable scenarios with low priority (with @p2 tag)') do |t|
    t.rspec_opts = "#{RSPEC_OPTS} --tag p2 --tag ~wip --tag ~bug"
  end
end

task default: :features
