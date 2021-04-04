# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'rake'
gem 'puma'
gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-contrib'
gem 'faraday'
gem 'faraday_middleware'
gem 'i18n'
gem 'config'
gem 'pg', '~> 1.2.3'
gem 'sequel'
gem 'bunny'
gem 'dry-initializer'
gem 'dry-validation'

gem 'activesupport', require: false

gem 'fast_jsonapi'


group :development, :test do
  gem 'rspec'
  gem 'factory_bot'
  gem 'rack-test'
  gem 'database_cleaner-sequel'
end
