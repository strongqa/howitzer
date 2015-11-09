require 'cucumber'
require 'cucumber/rake/task'
CUCUMBER_OPTS = "-r features -v -x -f html -o ./#{settings.log_dir}/#{settings.html_log}" \
                " -f junit -o ./#{settings.log_dir} -f pretty"

Cucumber::Rake::Task.new(:cucumber, 'Run all cucumber scenarios') do |t|
  t.fork = false
  t.cucumber_opts = CUCUMBER_OPTS
end

Cucumber::Rake::Task.new(:features, 'Run all workable scenarios (without @wip and @bug tags)') do |t|
  t.fork = false
  t.cucumber_opts = "#{CUCUMBER_OPTS} --tags ~@wip --tags ~@bug"
end

namespace :features do
  Cucumber::Rake::Task.new(:wip, 'Run scenarios in progress (with @wip tag)') do |t|
    t.fork = false
    t.cucumber_opts = "#{CUCUMBER_OPTS} --tags @wip"
  end

  Cucumber::Rake::Task.new(:bug, 'Run scenarios with known bugs (with @bug tag)') do |t|
    t.fork = false
    t.cucumber_opts = "#{CUCUMBER_OPTS} --tags @bug"
  end

  Cucumber::Rake::Task.new(:smoke, 'Run workable smoke scenarios (with @smoke tag)') do |t|
    t.fork = false
    t.cucumber_opts = "#{CUCUMBER_OPTS} --tags @smoke --tags ~@wip --tags ~@bug"
  end

  Cucumber::Rake::Task.new(:bvt, 'Run workable build verification test scenarios') do |t|
    t.fork = false
    t.cucumber_opts = "#{CUCUMBER_OPTS} --tags ~@wip --tags ~@bug --tags ~@smoke --tags ~@p1 --tags ~@p2"
  end

  Cucumber::Rake::Task.new(:p1, 'Run workable scenarios with normal priority (with @p1 tag)') do |t|
    t.fork = false
    t.cucumber_opts = "#{CUCUMBER_OPTS} --tags ~@wip --tags ~@bug --tags @p1"
  end

  Cucumber::Rake::Task.new(:p2, 'Run workable scenarios with low priority (with @p2 tag)') do |t|
    t.fork = false
    t.cucumber_opts = "#{CUCUMBER_OPTS} --tags ~@wip --tags ~@bug --tags @p2"
  end
end

task default: :features
