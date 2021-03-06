# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'app_configuration'
gem 'cinch', github: 'phaul/cinch'
gem 'dry-equalizer', '~> 0.3'
gem 'dry-initializer', '~> 3.0'
gem 'dry-schema', '~> 1.6'
gem 'dry-types', '~> 1.5'
gem 'faker', '~> 2.17'
gem 'parslet', '~> 2.0'
gem 'sequel', '~> 5.43'
gem 'sqlite3', '~> 1.4'
gem 'typhoeus', '~> 1.4'

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'mutant-rspec'
  gem 'nokogiri'
  gem 'pry'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'reek'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'rubocop-sequel'
end

group :development, :test do
  gem 'database_cleaner-sequel'
  gem 'deep-cover'
  gem 'factory_bot'
  gem 'rspec'
end

# Specify your gem's dependencies in yarr.gemspec
gemspec
