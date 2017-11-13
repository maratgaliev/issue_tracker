source 'https://rubygems.org'

gem 'rails', '~> 5.1.4'
gem 'puma', '~> 3.7'
gem 'active_model_serializers', '0.10'
gem 'devise'
gem 'devise-jwt'
gem 'dry-validation'
gem 'dry-transaction'
gem 'will_paginate'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :development, :test do
  gem 'sqlite3'

  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'byebug'

  gem 'rspec-rails', '~> 3.6'
  gem 'rspec-its'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'factory_bot'
end

group :production do
  gem 'pg'
end
