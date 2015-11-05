require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:features) { |features| }

unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks
  begin

    namespace :features do
      RSpec::Core::RakeTask.new(:wip, 'Run features that are being worked on') do |t|
        t.pattern = './spec{,/*/**}/*_spec.rb'
        t.rspec_opts = '--tag wip'
      end

      RSpec::Core::RakeTask.new(:bug, 'Run features with known bugs') do |t|
        t.pattern = './spec{,/*/**}/*_spec.rb'
        t.rspec_opts = '--tag bug'
      end

      RSpec::Core::RakeTask.new(:smoke, 'Run smoke features') do |t|
        t.pattern = './spec{,/*/**}/*_spec.rb'
        t.rspec_opts = '--tag smoke'
      end

      RSpec::Core::RakeTask.new(:bvt, 'Run bvt features') do |t|
        t.pattern = './spec{,/*/**}/*_spec.rb'
        t.rspec_opts = '--tag bvt'
      end

      RSpec::Core::RakeTask.new(:p1, 'Run p1 features') do |t|
        t.pattern = './spec{,/*/**}/*_spec.rb'
        t.rspec_opts = '--tag p1'
      end

      RSpec::Core::RakeTask.new(:p2, 'Run p2 features') do |t|
        t.pattern = './spec{,/*/**}/*_spec.rb'
        t.rspec_opts = '--tag p2'
      end
    end
  end
end

task default: :features
