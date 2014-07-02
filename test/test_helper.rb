ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "database_cleaner"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
require "minitest/pride"
require "minitest/mock"

require 'factory_girl_rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

DatabaseCleaner.strategy = :transaction

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

def json(response, key)
  json = ActiveSupport::JSON.decode response.body
  key ? json[key].symbolize_keys : json.symbolize_keys
end

