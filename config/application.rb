require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Nufia7
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec, spec: true
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_job.queue_adapter = Settings.active_job.queue_adapter

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

    # The compile method (default in tinymce-rails 4.5.2) doesn't work when also
    # using tinymce-rails-imageupload, so revert to the :copy method
    # https://github.com/spohlenz/tinymce-rails/issues/183
    config.tinymce.install = :copy

    if ENV['REDIS_HOST']
      redis_host = ENV['REDIS_HOST']
      redis_port = ENV['REDIS_PORT'] || 6379

      config.cache_store = :redis_store, {
        host: redis_host,
        port: redis_port,
        db: 0,
        namespace: "_#{Rails.application.class.parent_name.downcase}_cache",
        expires_in: 30.days
      }
    end

    if Settings&.active_job&.queue_adapter.present?
      # rubocop:disable Lint/HandleExceptions
      begin
        require Settings.active_job.queue_adapter.to_s
      rescue LoadError
      end
      # rubocop:enable Lint/HandleExceptions
      config.active_job.queue_adapter = Settings.active_job.queue_adapter.to_s
    else
      config.active_job.queue_adapter = :sidekiq
    end

    config.active_job.queue_name_prefix = Settings&.active_job&.queue_name_prefix
    config.active_job.queue_name_delimiter = Settings&.active_job&.queue_name_delimiter || (config.active_job.queue_name_prefix.present? ? '-' : nil)
    default_queue_name = [
      config.active_job.queue_name_prefix,
      Settings&.active_job&.default_queue_name || 'default'
    ].join(config.active_job.queue_name_delimiter)
    ActionMailer::Base.deliver_later_queue_name = ActiveJob::Base.queue_name = default_queue_name

    config.action_dispatch.default_headers = { 'X-Frame-Options' => 'ALLOWALL' }
  end
end
