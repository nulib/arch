# config valid only for current version of Capistrano
lock '3.9'

set :application, 'institutional_repository'
set :repo_url, 'git@github.com:/nulib/institutional-repository.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/nufia'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/analytics.yml', 'config/blacklight.yml', 'config/browse_everything_providers.yml', 'config/database.yml', 'config/fedora.yml', 'config/ldap.yml', 'config/redis.yml', 'config/role_map.yml', 'config/secrets.yml', 'config/sidekiq.yml', 'config/solr.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'tmp/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

#sidekiq
set :sidekiq_role, :app
set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
set :pty,  false # for Capistrano 3.x
set :sidekiq_monit_use_sudo, false


namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

  desc "Add symlinks for nufia config files"
  task :create_symlink do
    on roles(:app) do
      execute "ln -s /usr/local/nufia/nufia_config/nufia_config/config/analytics.yml /var/www/nufia/shared/config/analytics.yml"
            info "Created analytics.yml symlink"
      execute "ln -s /usr/local/nufia/nufia_config/nufia_config/config/blacklight.yml /var/www/nufia/shared/config/blacklight.yml"
            info "Created blacklight.yml symlink"
      execute "ln -s /usr/local/nufia/nufia_config/nufia_config/config/browse_everything_providers.yml /var/www/nufia/shared/config/browse_everything_providers.yml"
            info "Created browse_everything_providers.yml symlink"
      execute "ln -s /usr/local/nufia/nufia_config/nufia_config/config/database.yml /var/www/nufia/shared/config/database.yml"
            info "Created database.yml symlink"
      execute "ln -s /usr/local/nufia/nufia_config/nufia_config/config/fedora.yml /var/www/nufia/shared/config/fedora.yml"
            info "Created fedora.yml symlink"
      execute "ln -s /usr/local/nufia/nufia_config/nufia_config/config/ldap.yml /var/www/nufia/shared/config/ldap.yml"
            info "Created ldap.yml symlink"
      execute "ln -s /usr/local/nufia/nufia_config/nufia_config/config/redis.yml /var/www/nufia/shared/config/redis.yml"
            info "Created redis.yml symlink"
      execute "ln -s /usr/local/nufia/nufia_config/nufia_config/config/role_map.yml /var/www/nufia/shared/config/role_map.yml"
            info "Created role_map.yml symlink"
      execute "ln -s /usr/local/nufia/nufia_config/nufia_config/config/secrets.yml /var/www/nufia/shared/config/secrets.yml"
            info "Created secrets.yml symlink"
      execute "ln -s /usr/local/nufia/nufia_config/nufia_config/config/sidekiq.yml /var/www/nufia/shared/config/sidekiq.yml"
            info "Created sidekiq.yml symlink"
      execute "ln -s /usr/local/nufia/nufia_config/nufia_config/config/solr.yml /var/www/nufia/shared/config/solr.yml"
            info "Created solr.yml symlink"
    end
  end
