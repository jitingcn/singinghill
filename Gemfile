source "https://rubygems.org/"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rexml"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 7", "< 7.1"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma", "~> 6.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
gem "hiredis"
gem "redis", "~> 4.0", require: ["redis", "redis/connection/hiredis"]
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem "image_processing", ">= 1.2"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  gem "bullet"
  gem "debug"
  gem "dotenv-rails"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "listen", "~> 3.3"
  gem "pry"
  gem "rack-mini-profiler"
  gem "rubocop"
  gem "standard"
  gem "standard-rails"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "devise"

gem "hotwire-rails"

gem "turbo-rails", "~> 0.8", "< 7"

gem "view_component"

gem "rack-brotli"

gem "action_policy"

gem "audit-log", github: "jitingcn/audit-log"

gem "lograge"

# gem "natto", "~> 1.2"

gem "config", "~> 3.0"

gem "vite_rails", "~> 3.0"

gem "stimulus_reflex", "3.5.0.rc3"

gem "madmin", "~> 1.0", github: "jitingcn/madmin", branch: "dev"

gem "omniauth"
gem "omniauth-rails_csrf_protection"

gem "omniauth-gitlab"

gem "kaminari"

gem "meilisearch-rails", "~> 0.10.0"

gem "vite_plugin_legacy", "~> 3.0"

gem "paper_trail", "~> 12"

gem "redis-actionpack", github: "redis-store/redis-actionpack"

gem "pagy"

gem "kredis", "~> 1.1"

gem "pretender", "~> 0.4.0"

gem "stackprof"
gem "sentry-ruby"
gem "sentry-rails"
