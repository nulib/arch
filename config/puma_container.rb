directory '/home/app/current'
threads 8, 32
workers `grep -c processor /proc/cpuinfo`
port ENV.fetch('PORT') { 3000 }
pidfile '/var/run/puma/puma.pid'
stdout_redirect '/var/log/puma/puma.log', '/var/log/puma/puma.log', true
daemonize false
preload_app!
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
