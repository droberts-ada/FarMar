require 'simplecov'
require 'csv'

SimpleCov.start
require_relative '../farmar'
require 'minitest'
require 'minitest/spec'
require "minitest/autorun"
require "minitest/reporters"
require 'minitest/pride'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Toggle tests back and forth between well-known test data
# and complex production data
def use_production_data
  FarMar::Market.data_path = 'support/markets.csv'
  FarMar::Product.data_path = 'support/products.csv'
  FarMar::Sale.data_path = 'support/sales.csv'
  FarMar::Vendor.data_path = 'support/vendors.csv'
end

def use_test_data
  FarMar::Market.data_path = 'spec/test_data/markets.csv'
  FarMar::Product.data_path = 'spec/test_data/products.csv'
  FarMar::Sale.data_path = 'spec/test_data/sales.csv'
  FarMar::Vendor.data_path = 'spec/test_data/vendors.csv'
end
