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
gem 'docker-stack'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'better_errors'
  gem 'solr_wrapper', '>= 0.3'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'capybara', '~> 2.8'
  gem 'fcrepo_wrapper'
  gem 'rspec-rails', '~> 3.6'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Use Capistrano for deployment
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-sidekiq'
  gem 'rb-readline'
end


