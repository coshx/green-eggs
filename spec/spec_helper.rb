# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__) unless defined?(Rails)
require 'rspec/rails'
require 'mongoid-rspec'
require 'factory_girl'
require 'email_spec'

require Rails.root.join("spec", "factories.rb")

RSpec.configure do |config|
  include Mongoid::Matchers
  
  config.mock_with :rspec

  # Clean up the database
  require 'database_cleaner'
  config.before(:suite) do
    begin
      DatabaseCleaner.strategy = :truncation
    rescue NameError
      raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
    end
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end

end
