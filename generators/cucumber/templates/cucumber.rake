require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber, 'Run all tests')

Cucumber::Rake::Task.new(:features, 'Run default rake task') do |t|
  t.cucumber_opts = '--tag ~wip --tag ~bug'
end

begin

  namespace :features do
    Cucumber::Rake::Task.new(:wip, 'Run features that are being worked on') do |t|
      t.fork = false
      t.profile = 'wip'
    end

    Cucumber::Rake::Task.new(:bug, 'Run features with known bugs') do |t|
      t.fork = false
      t.profile = 'bug'
    end

    Cucumber::Rake::Task.new(:smoke, 'Run smoke features') do |t|
      t.fork = false
      t.profile = 'smoke'
    end

    Cucumber::Rake::Task.new(:bvt, 'Run bvt features') do |t|
      t.fork = false
      t.profile = 'bvt'
    end

    Cucumber::Rake::Task.new(:p1, 'Run p1 features') do |t|
      t.fork = false
      t.profile = 'p1'
    end

    Cucumber::Rake::Task.new(:p2, 'Run p2 features') do |t|
      t.fork = false
      t.profile = 'p2'
    end
  end
end

task default: :features
