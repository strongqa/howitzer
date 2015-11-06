require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:rspec, 'Run all turnip scenarios')

RSpec::Core::RakeTask.new(:features, 'Run all workable scenarios (without @wip and @bug tags)') do |t|
  t.pattern = './spec{,/*/**}/*.feature'
  t.rspec_opts = '--tag ~wip --tag ~bug'
end

begin

  namespace :features do
    RSpec::Core::RakeTask.new(:wip, 'Run scenarios in progress (with @wip tag)') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag wip'
    end

    RSpec::Core::RakeTask.new(:bug, 'Run scenarios with known bugs (with @bug tag)') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag bug'
    end

    RSpec::Core::RakeTask.new(:smoke, 'Run workable smoke scenarios (with @smoke tag)') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag smoke --tag ~wip --tag ~bug'
    end

    RSpec::Core::RakeTask.new(:bvt, 'Run workable build verification test scenarios (with @bvt tag)') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag bvt --tag ~wip --tag ~bug --tag ~p1 --tag ~p2 --tag ~smoke'
    end

    RSpec::Core::RakeTask.new(:p1, 'Run workable scenarios with priority 1 (with @p1 tag)') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag p1 --tag ~wip --tag ~bug'
    end

    RSpec::Core::RakeTask.new(:p2, 'Run workable scenarios with priority 2 (with @p2 tag)') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag p2 --tag ~wip --tag ~bug'
    end
  end
end

task default: :features
