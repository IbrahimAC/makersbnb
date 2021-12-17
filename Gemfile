# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '3.0.0'
group :test do
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
  gem "webmock", "~> 3.14"
end

group :development, :test do
  gem 'capybara'
  gem 'pg'
  gem 'rspec'
  gem 'rubocop', '1.23.0'
  gem 'sinatra'
  gem 'webrick'
  gem "dotenv", "~> 2.7"
  gem 'sinatra-flash', '~> 0.3.0'
  gem 'rack', '~> 2.2'
  gem 'sinatra-contrib', '~> 2.1'
  gem 'bcrypt', '~> 3.1'
  gem "sendgrid-ruby", "~> 6.6"
end
