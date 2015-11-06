require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber, 'Run all cucumber scenarios')

Cucumber::Rake::Task.new(:features, 'Run all workable scenarios (without @wip and @bug tags)') do |t|
  t.profile = 'default'
end

begin

  namespace :features do
    Cucumber::Rake::Task.new(:wip, 'Run scenarios in progress (with @wip tag)') do |t|
      t.fork = false
      t.profile = 'wip'
    end

    Cucumber::Rake::Task.new(:bug, 'Run scenarios with known bugs (with @bug tag)') do |t|
      t.fork = false
      t.profile = 'bug'
    end

    Cucumber::Rake::Task.new(:smoke, 'Run workable smoke scenarios (with @smoke tag)') do |t|
      t.fork = false
      t.profile = 'smoke'
    end

    Cucumber::Rake::Task.new(:bvt, 'Run workable build verification test scenarios (with @bvt tag)') do |t|
      t.fork = false
      t.profile = 'bvt'
    end

    Cucumber::Rake::Task.new(:p1, 'Run workable scenarios with priority 1 (with @p1 tag)') do |t|
      t.fork = false
      t.profile = 'p1'
    end

    Cucumber::Rake::Task.new(:p2, 'Run workable scenarios with priority 2 (with @p2 tag)') do |t|
      t.fork = false
      t.profile = 'p2'
    end
  end
end

task default: :features
