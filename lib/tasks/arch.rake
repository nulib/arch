unless Rails.env.production?
  require 'rspec/core/rake_task'
  require 'active_fedora/rake_support'

  namespace :arch do
    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.rspec_opts = ['--color', '--backtrace']
    end

    desc 'Run all Continuous Integration tests'
    task :ci do
      Rake::Task['arch:ci:rspec'].invoke
    end

    namespace :ci do
      desc 'Execute Continuous Integration build'
      task :rspec do
        Rake::Task['docker:spec'].invoke
      end
    end
  end
end
