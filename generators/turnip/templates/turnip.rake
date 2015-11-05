require 'rspec/core/rake_task'

unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks
  begin

    namespace :turnip do
      RSpec::Core::RakeTask.new(:ok, 'Run features that should pass') do |t|
        t.pattern = './spec{,/*/**}/*.feature'
        t.rspec_opts = '--tag default'
      end

      RSpec::Core::RakeTask.new(:wip, 'Run features that are being worked on') do |t|
        t.pattern = './spec{,/*/**}/*.feature'
        t.rspec_opts = '--tag wip'
      end

      RSpec::Core::RakeTask.new(:bug, 'Run features with known bugs') do |t|
        t.pattern = './spec{,/*/**}/*.feature'
        t.rspec_opts = '--tag bug'
      end

      RSpec::Core::RakeTask.new(:demo, 'Run demo feature') do |t|
        t.pattern = './spec{,/*/**}/*.feature'
        t.rspec_opts = '--tag demo'
      end

      RSpec::Core::RakeTask.new(:smoke, 'Run smoke feature') do |t|
        t.pattern = './spec{,/*/**}/*.feature'
        t.rspec_opts = '--tag smoke'
      end

      RSpec::Core::RakeTask.new(:rerun, 'Record failing features and run only them if any exist') do |t|
        t.pattern = './spec{,/*/**}/*.feature'
        t.rspec_opts = '--tag rerun'
      end

      desc 'Run all features'
      task all: [:ok, :wip]
    end

    task default: 'turnip:ok'

    task features: 'turnip:ok' do
      STDERR.puts "*** The 'features' task is deprecated. See rake -T turnip ***"
    end

  rescue LoadError
    desc 'turnip rake task not available (turnip not installed)'
    task :turnip do
      abort 'Turnip rake task is not available. Be sure to install turnip as a gem or plugin'
    end
  end

  task :smoke do
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = '--tag smoke'
    end
    Rake::Task['spec'].execute
  end

  task :bvt do
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = '--tag bvt'
    end
    Rake::Task['spec'].execute
  end

  task p1: [:turnip] do
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = '--tag p1'
    end
    Rake::Task['spec'].execute
  end

  task p2: [:default] do
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = '--tag p2'
    end
    Rake::Task['spec'].execute
  end

end
