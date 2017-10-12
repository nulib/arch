
DOI = YAML.load_file(Rails.root.join('config', 'doi_credentials.yml'))[Rails.env]

Ezid::Client.configure do |conf|
    conf.default_shoulder = DOI['default_shoulder']
    conf.user = DOI['user']
    conf.password = DOI['password']
    conf.host = DOI['host']
    conf.port = DOI['port']
    conf.use_ssl = DOI['use_ssl']
end