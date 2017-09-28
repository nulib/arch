namespace :arch do
  desc 'Print environment variables'
  task :env do
    on roles(:all) do
      execute "env"
    end
  end
end
