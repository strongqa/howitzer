
unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks
  begin
    require 'cucumber'
    require 'cucumber/rake/task'

    namespace :cucumber do
      Cucumber::Rake::Task.new({ ok: 'db:test:prepare' }, 'Run features that should pass') do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'default'
      end

      Cucumber::Rake::Task.new({ wip: 'db:test:prepare' }, 'Run features that are being worked on') do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'wip'
      end

      Cucumber::Rake::Task.new({ bug: 'db:test:prepare' }, 'Run features with known bugs') do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'bug'
      end

      Cucumber::Rake::Task.new({ demo: 'db:test:prepare' }, 'Run demo feature') do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'demo'
      end

      Cucumber::Rake::Task.new({ smoke: 'db:test:prepare' }, 'Run smoke feature') do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'smoke'
      end

      Cucumber::Rake::Task.new(
        { rerun: 'db:test:prepare' },
        'Record failing features and run only them if any exist'
      ) do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'rerun'
      end

      desc 'Run all features'
      task all: [:ok, :wip]
    end
    desc 'Alias for cucumber:ok'
    task cucumber: 'cucumber:ok'

    task default: :cucumber

    task features: :cucumber do
      STDERR.puts "*** The 'features' task is deprecated. See rake -T cucumber ***"
    end

    # In case we don't have ActiveRecord, append a no-op task that we can depend upon.
    task 'db:test:prepare' do
    end

  rescue LoadError
    desc 'cucumber rake task not available (cucumber not installed)'
    task :cucumber do
      abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
    end
  end

end

begin
  require 'rspec/core/rake_task'

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

  task p1: ['cucumber:ok'] do
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
