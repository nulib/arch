
# prod
# EZID_DEFAULT_SHOULDER: doi:10.21985/N2
# EZID_USER: nu-lib
# EZID_PASSWORD: ?Sh0tJ.R.R
# EZID_HOST: ezid.lib.purdue.edu\
# EZID_PORT: 443
# EZID_USE_SSL: true

Ezid::Client.configure do |conf|
  conf.default_shoulder = 'doi:10.5072/FK2' unless ENV['EZID_DEFAULT_SHOULDER']
  conf.user = 'apitest' unless ENV['EZID_USER']
  conf.password = 'apitest' unless ENV['EZID_PASSWORD']
  conf.host = 'ezid.lib.purdue.edu' unless ENV['EZID_HOST']
  conf.port = 443 unless ENV['EZID_PORT']
  conf.use_ssl = true unless ENV['EZID_USE_SSL']
end