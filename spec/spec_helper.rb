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
