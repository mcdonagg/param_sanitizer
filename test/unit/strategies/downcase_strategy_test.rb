require 'unit/test_helper'

module ParamSanitizer
  module Strategies
    class DowncaseStrategyTest < ParamSanitizer::UnitTest
      
      def setup
        @sanitizer = DowncaseStrategy.new
      end
      
      test "it should not convert a request that is lowercase" do
        assert_sanitized_request(@sanitizer, 'foo_bar_baz', 'foo_bar_baz')        
      end
      
      test "it should convert a request with upper case in a specific query parameter to lower case" do
        assert_sanitized_request(@sanitizer, 'foo-bar-baz', 'fOO-bar-baz')
      end
    end
  end
end