require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:rspec, 'Run all tests')

RSpec::Core::RakeTask.new(:features, 'Run default rake task') do |t|
  t.pattern = './spec{,/*/**}/*.feature'
  t.rspec_opts = '--tag ~wip --tag ~bug'
end

begin

  namespace :features do
    RSpec::Core::RakeTask.new(:wip, 'Run features that are being worked on') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag wip'
    end

    RSpec::Core::RakeTask.new(:bug, 'Run features with known bugs') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag bug'
    end

    RSpec::Core::RakeTask.new(:smoke, 'Run smoke features') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag smoke --tag ~wip --tag ~bug'
    end

    RSpec::Core::RakeTask.new(:bvt, 'Run bvt features') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag bvt --tag ~wip --tag ~bug --tag ~p1 --tag ~p2 --tag ~smoke'
    end

    RSpec::Core::RakeTask.new(:p1, 'Run p1 features') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag p1 --tag ~wip --tag ~bug'
    end

    RSpec::Core::RakeTask.new(:p2, 'Run p2 features') do |t|
      t.pattern = './spec{,/*/**}/*.feature'
      t.rspec_opts = '--tag p2 --tag ~wip --tag ~bug'
    end
  end
end

task default: :features