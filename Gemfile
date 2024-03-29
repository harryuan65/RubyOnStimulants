source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

gem 'coffee-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
gem 'redis'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'redcarpet'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.1'
end
gem 'solargraph', group: :development
group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem "rubocop-rails", "~> 2.9"
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'faker'
  gem 'dotenv-rails'
  gem 'annotate'
  gem 'bullet'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
end
gem 'active_model_serializers'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'rest-client'
gem 'mime-types'
gem 'netrc'
gem 'http-accept'
gem 'http-cookie'
gem 'pg'
gem 'pry-rails'
gem 'jquery-rails'

gem 'devise'#, :git => "https://github.com/heartcombo/devise.git", ref: '8bb358cf80a632d3232c3f548ce7b95fd94b6eb2'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'dalli' #for mem_cached_store for precompile
gem 'line-bot-api'
gem 'rails_param'
gem 'gutentag'
gem "jquery-ui-rails"
gem "acts_as_list"
gem 'rollbar'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'rubyzip'

gem 'sidekiq'
gem 'sidekiq-scheduler'
gem "thread_safe"

gem "omniauth", "= 1.9.1"
gem "webpacker"
gem "terser", "~> 1.1"