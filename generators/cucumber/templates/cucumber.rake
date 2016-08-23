require 'cucumber'
require 'cucumber/rake/task'

opts = lambda do |task_name|
  [
    '-r features',
    '-v',
    '-x',
    "-f html -o ./#{Howitzer.log_dir}/#{Howitzer.driver}_#{task_name}_#{Howitzer.html_log}",
    "-f junit -o ./#{Howitzer.log_dir}",
    '-f pretty'
  ].join(' ').freeze
end

Cucumber::Rake::Task.new(:cucumber, 'Run all cucumber scenarios') do |t|
  Howitzer.current_rake_task = t.instance_variable_get :@task_name
  t.fork = false
  t.cucumber_opts = opts.call(t.instance_variable_get(:@task_name))
end

Cucumber::Rake::Task.new(:features, 'Run all workable scenarios (without @wip and @bug tags)') do |t|
  Howitzer.current_rake_task = t.instance_variable_get :@task_name
  t.fork = false
  t.cucumber_opts = "#{opts.call(t.instance_variable_get(:@task_name))} --tags ~@wip --tags ~@bug"
end

namespace :features do
  Cucumber::Rake::Task.new(:wip, 'Run scenarios in progress (with @wip tag)') do |t|
    Howitzer.current_rake_task = t.instance_variable_get :@task_name
    t.fork = false
    t.cucumber_opts = "#{opts.call(t.instance_variable_get(:@task_name))} --tags @wip"
  end

  Cucumber::Rake::Task.new(:bug, 'Run scenarios with known bugs (with @bug tag)') do |t|
    Howitzer.current_rake_task = t.instance_variable_get :@task_name
    t.fork = false
    t.cucumber_opts = "#{opts.call(t.instance_variable_get(:@task_name))} --tags @bug"
  end

  Cucumber::Rake::Task.new(:smoke, 'Run workable smoke scenarios (with @smoke tag)') do |t|
    Howitzer.current_rake_task = t.instance_variable_get :@task_name
    t.fork = false
    t.cucumber_opts = "#{opts.call(t.instance_variable_get(:@task_name))} --tags @smoke --tags ~@wip --tags ~@bug"
  end

  Cucumber::Rake::Task.new(:bvt, 'Run workable build verification test scenarios') do |t|
    Howitzer.current_rake_task = t.instance_variable_get :@task_name
    t.fork = false
    t.cucumber_opts = "#{opts.call(t.instance_variable_get(:@task_name))}
    --tags ~@wip --tags ~@bug --tags ~@smoke --tags ~@p1 --tags ~@p2"
  end

  Cucumber::Rake::Task.new(:p1, 'Run workable scenarios with normal priority (with @p1 tag)') do |t|
    Howitzer.current_rake_task = t.instance_variable_get :@task_name
    t.fork = false
    t.cucumber_opts = "#{opts.call(t.instance_variable_get(:@task_name))} --tags ~@wip --tags ~@bug --tags @p1"
  end

  Cucumber::Rake::Task.new(:p2, 'Run workable scenarios with low priority (with @p2 tag)') do |t|
    Howitzer.current_rake_task = t.instance_variable_get :@task_name
    t.fork = false
    t.cucumber_opts = "#{opts.call(t.instance_variable_get(:@task_name))} --tags ~@wip --tags ~@bug --tags @p2"
  end
end

task default: :features
