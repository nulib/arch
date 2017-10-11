
# prod
# EZID_DEFAULT_SHOULDER: doi:10.21985/N2
# EZID_USER: nu-lib
# EZID_PASSWORD: ?Sh0tJ.R.R
# EZID_HOST: ezid.lib.purdue.edu\
# EZID_PORT: 443
# EZID_USE_SSL: true

Ezid::Client.configure do |conf|
  if Rails.env.production? || Rails.env.staging?
    conf.default_shoulder = ENV['EZID_DEFAULT_SHOULDER']
    conf.user = ENV['EZID_USER']
    conf.password = ENV['EZID_PASSWORD']
    conf.host = ENV['EZID_HOST']
    conf.port = ENV['EZID_PORT']
    conf.use_ssl = ENV['EZID_USE_SSL']
  else
    conf.default_shoulder = 'doi:10.5072/FK2'
    conf.user = 'apitest'
    conf.password = 'apitest'
    conf.host = 'ezid.lib.purdue.edu'
    conf.port = 443
    conf.use_ssl = true
  end
end