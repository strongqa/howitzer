require 'rspec/core/rake_task'

opts = lambda do |task_name|
  [
    "--format html --out ./#{Howitzer.log_dir}/#{Howitzer.driver}_#{task_name}_#{Howitzer.html_log}",
    '--format documentation',
    '--color'
  ].join(' ').freeze
end

RSpec::Core::RakeTask.new(:rspec, 'Run all rspec scenarios') do |t|
  Howitzer.current_rake_task = t.name
  t.opts = opts.call(t.name)
end

RSpec::Core::RakeTask.new(:features, 'Run all workable scenarios (without @wip and @bug tags)') do |t|
  Howitzer.current_rake_task = t.name
  t.opts = "#{opts.call(t.name)} --tag ~wip --tag ~bug"
end

namespace :features do
  RSpec::Core::RakeTask.new(:wip, 'Run scenarios in progress (with @wip tag)') do |t|
    Howitzer.current_rake_task = t.name
    t.opts = "#{opts.call(t.name)} --tag wip"
  end

  RSpec::Core::RakeTask.new(:bug, 'Run scenarios with known bugs (with @bug tag)') do |t|
    Howitzer.current_rake_task = t.name
    t.opts = "#{opts.call(t.name)} --tag bug"
  end

  RSpec::Core::RakeTask.new(:smoke, 'Run workable smoke scenarios (with @smoke tag)') do |t|
    Howitzer.current_rake_task = t.name
    t.opts = "#{opts.call(t.name)} --tag smoke --tag ~wip --tag ~bug"
  end

  RSpec::Core::RakeTask.new(:bvt, 'Run workable build verification test scenarios') do |t|
    Howitzer.current_rake_task = t.name
    t.opts = "#{opts.call(t.name)} --tag ~wip --tag ~bug --tag ~p1 --tag ~p2 --tag ~smoke"
  end

  RSpec::Core::RakeTask.new(:p1, 'Run workable scenarios with normal priority (with @p1 tag)') do |t|
    Howitzer.current_rake_task = t.name
    t.opts = "#{opts.call(t.name)} --tag p1 --tag ~wip --tag ~bug"
  end

  RSpec::Core::RakeTask.new(:p2, 'Run workable scenarios with low priority (with @p2 tag)') do |t|
    Howitzer.current_rake_task = t.name
    t.opts = "#{opts.call(t.name)} --tag p2 --tag ~wip --tag ~bug"
  end
end

task default: :features
