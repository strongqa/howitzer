require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:rspec, 'Run all rspec scenarios')

RSpec::Core::RakeTask.new(:features, 'Run all workable scenarios (without @wip and @bug tags)') do |t|
  t.rspec_opts = '--tag ~wip --tag ~bug'
end

begin

  namespace :features do
    std_opts = "--format html --out=./#{settings.log_dir}/#{settings.html_log} --format documentation --color"
    RSpec::Core::RakeTask.new(:wip, 'Run scenarios in progress (with @wip tag)') do |t|
      t.rspec_opts = "#{std_opts} --tag wip"
    end

    RSpec::Core::RakeTask.new(:bug, 'Run scenarios with known bugs (with @bug tag)') do |t|
      t.rspec_opts = "#{std_opts} --tag bug"
    end

    RSpec::Core::RakeTask.new(:smoke, 'Run workable smoke scenarios (with @smoke tag)') do |t|
      t.rspec_opts = "#{std_opts} --tag smoke --tag ~wip --tag ~bug"
    end

    RSpec::Core::RakeTask.new(:bvt, 'Run workable build verification test scenarios') do |t|
      t.rspec_opts = "#{std_opts} --tag ~wip --tag ~bug --tag ~p1 --tag ~p2 --tag ~smoke"
    end

    RSpec::Core::RakeTask.new(:p1, 'Run workable scenarios with normal priority (with @p1 tag)') do |t|
      t.rspec_opts = "#{std_opts} --tag p1 --tag ~wip --tag ~bug"
    end

    RSpec::Core::RakeTask.new(:p2, 'Run workable scenarios with low priority (with @p2 tag)') do |t|
      t.rspec_opts = "#{std_opts} --tag p2 --tag ~wip --tag ~bug"
    end
  end
end

task default: :features
