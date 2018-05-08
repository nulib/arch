Ezid::Client.configure do |conf|
  Settings.doi_credentials.tap do |doi|
    conf.default_shoulder = doi.default_shoulder
    conf.user = doi.user
    conf.password = doi.password
    conf.host = doi.host
    conf.port = doi.port
    conf.use_ssl = doi.use_ssl
  end
end
