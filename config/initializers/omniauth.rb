Rails.application.config.middleware.use OmniAuth::Builder do
  provider :nusso,
           Settings.nusso.base_url,
           Settings.nusso.consumer_key
end
