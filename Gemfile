source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 1.0.0', group: :doc

gem 'rubyzip', '>= 1.0.0', require: 'zip'
gem 'sidekiq'
gem 'sinatra', '>= 2.0.0', require: nil
gem 'yaml_db'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

gem 'hydra-derivatives', git: 'https://github.com/nulib/hydra-derivatives.git', branch: 'vips'
gem 'hyrax', github: 'nulib/hyrax', branch: '2.4.1-plus-be'

# Admin users enabled by hydra-role-management
gem 'hydra-role-management'

# Added for NUfia
gem 'devise_ldap_authenticatable', '~> 0.8.5'

# Lock pg to < 1 until we upgrade rails past 5.1.5
# https://github.com/rails/rails/issues/31673#issuecomment-365126536
gem 'pg', '~> 0.21'
gem 'sqlite3'

gem 'config'
gem 'devise'
gem 'devise-guests', '~> 0.3'
gem 'honeybadger', '~> 4.0'
gem 'omniauth-openam'
gem 'recaptcha'
gem 'rsolr', '~> 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'

gem 'docker-stack'

gem 'zk'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'capybara', '~> 2.8'
  gem 'fcrepo_wrapper'
  gem 'rspec-rails', '~> 3.6'
  gem 'rubocop', '~> 0.49.1', require: false
  gem 'rubocop-rspec', require: false
  gem 'solr_wrapper', '>= 0.3'
  gem 'webmock'
  gem 'xray-rails'
end

group :aws, :test do
  gem 'active_elastic_job', git: 'https://github.com/nulib/active-elastic-job.git', branch: 'latest-aws-sdk'
end

group :aws do
  gem 'aws-sdk', '~> 3'
  gem 'aws-sdk-rails'
  gem 'carrierwave-aws'
  gem 'cloudfront-signer'
  gem 'redis-rails'
end

group :production do
  gem 'lograge'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rb-readline'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
end
