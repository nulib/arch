source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'sidekiq'
gem 'sinatra', '>= 2.0.0', :require => nil
gem 'ezid-client'


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

gem 'hyrax', '~> 1.0', '>= 1.0.2'

# Admin users enabled by hydra-role-management
gem 'hydra-role-management'

# Added for NUfia
gem 'devise_ldap_authenticatable', '~> 0.8.5'

# Lock pg to < 1 until we upgrade rails past 5.1.5
# https://github.com/rails/rails/issues/31673#issuecomment-365126536
gem 'pg', '~> 0.21'
gem 'config'
gem 'rsolr', '~> 1.0'
gem 'devise'
gem 'devise-guests', '~> 0.3'
gem 'omniauth-openam'
# Use Puma as the app server
gem 'puma', '~> 3.7'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'better_errors'
  gem 'solr_wrapper', '>= 0.3'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'capybara', '~> 2.8'
  gem 'fcrepo_wrapper'
  gem 'rspec-rails', '~> 3.6'
  gem 'docker-stack'
end

group :aws, :test do
  gem 'active_elastic_job', github: 'nulib/active-elastic-job', branch: 'latest-aws-sdk'
end

group :aws do
  gem 'aws-sdk', '~> 3'
  gem 'aws-sdk-rails'
  gem 'carrierwave-aws'
  gem 'cloudfront-signer'
  gem 'redis-rails'
  gem 'zk'
end

group :development do
  gem 'pry-byebug'
  gem 'rb-readline'
end
