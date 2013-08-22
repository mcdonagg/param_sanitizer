require 'panatizer'
require 'minitest/autorun'
require 'rack/mock'
require 'mocha/setup'

class Panatizer::TestCase < MiniTest::Unit::TestCase
  def self.test(test_description, &block)
    define_method "test_#{test_description.gsub(/\s/, '_')}", &block
  end
end