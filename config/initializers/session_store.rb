if ENV['REDIS_HOST']
  require 'rack-redis-session-store'

  redis_host = ENV['REDIS_HOST']
  redis_port = ENV['REDIS_PORT'] || 6379

  Rails.application.config.session_store :redis_store,
                                         host: redis_host,
                                         port: redis_port,
                                         expires_in: 90.minutes,
                                         key: "_#{Rails.application.class.parent_name.downcase}_session"
end
