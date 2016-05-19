if Rails.env.staging?

  Sidekiq.configure_server do |config|
    config.redis = { url: "redis://nufiarepo-s.library.northwestern.edu:6379/0", namespace: 'sidekiq' }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: "redis://nufiarepo-s.library.northwestern.edu:6379/0", namespace: 'sidekiq' }
  end
end


if Rails.env.production?

  Sidekiq.configure_server do |config|
    config.redis = { url: "redis://nufiarepo-plibrary.northwestern.edu:6379/0", namespace: 'sidekiq' }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: "redis://nufiarepo-p.library.northwestern.edu:6379/0", namespace: 'sidekiq' }
  end
end
