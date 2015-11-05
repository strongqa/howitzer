require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) {}

unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks
  begin

    namespace :features do
      Cucumber::Rake::Task.new({ wip: 'db:test:prepare' }, 'Run features that are being worked on') do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'wip'
      end

      Cucumber::Rake::Task.new({ bug: 'db:test:prepare' }, 'Run features with known bugs') do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'bug'
      end

      Cucumber::Rake::Task.new({ smoke: 'db:test:prepare' }, 'Run smoke features') do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'smoke'
      end

      Cucumber::Rake::Task.new({ bvt: 'db:test:prepare' }, 'Run bvt features') do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'bvt'
      end

      Cucumber::Rake::Task.new({ p1: 'db:test:prepare' }, 'Run p1 features') do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'p1'
      end

      Cucumber::Rake::Task.new({ p2: 'db:test:prepare' }, 'Run p2 features') do |t|
        t.fork = false # You may get faster startup if you set this to false
        t.profile = 'p2'
      end
    end
  end
end

task default: :features
