source 'http://rubygems.org'

gem 'rails', '~> 3.2.3'

gem 'haml'
gem 'haml-rails'
gem 'heroku'
gem 'json'
gem 'mongoid'
gem 'bson_ext'
gem 'therubyracer'
gem 'formtastic'

# real-time updating
gem 'firehose', :git => 'git://github.com/rahearn/firehose.git', :branch => 'topic/rails-engine'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'

group :development, :test do
  # fancy debugger
  gem "pry", "~> 0.9.7"
  gem "pry-nav", "~> 0.0.4"
  gem 'capybara'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl'
  gem 'mongoid-rspec', :require => false
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'capybara-webkit'
  gem 'guard'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-bundler'
  gem 'guard-migrate'
  gem 'guard-rake'
end

group :test do
  gem 'cucumber-rails'
end
