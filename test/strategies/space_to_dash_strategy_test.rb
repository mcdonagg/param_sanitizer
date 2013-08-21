require 'test_helper'
require 'rack/mock'

module Panatizer
  module Strategies
    class SpaceToDashStrategyTest < MiniTest::Unit::TestCase
      
      def setup
        @sanitizer = SpaceToDashStrategy.new
      end
      
      test "it should not convert a request that doesn't have spaces" do
        assert_sanitized_request(@sanitizer, 'foo_bar_baz', 'foo_bar_baz')        
      end
      
      test "it should convert a request with spaces in a specific query parameter to dashes" do
        assert_sanitized_request(@sanitizer, 'foo-bar-baz', 'foo bar baz')
      end
      
      test "it should convert a request with URI-encoded spaces in a specific query parameter to dashes" do
        assert_sanitized_request(@sanitizer, 'foo-bar-baz', 'foo%20bar%20baz')
      end
      
      test "it should not add dashes to the start or end of a string" do
        assert_sanitized_request(@sanitizer, 'foo-bar-baz', ' foo bar baz ')
      end
    end
  end
end