require 'unit/test_helper'

module ParamSanitizer
  module Strategies
    class StripSchemeStrategyTest < ParamSanitizer::UnitTest
      
      def setup
        @sanitizer = StripSchemeStrategy.new
      end
      
      test "it should not convert a request that doesn't have scheme" do
        assert_sanitized_request(@sanitizer, 'foo_bar_baz', 'foo_bar_baz')
      end
      
      test "it should remove a request with http scheme in the parameter" do
        assert_sanitized_request(@sanitizer, 'foo bar', 'http://foo bar')
      end
      
      test "it should remove a request with ftp scheme in the parameter" do
        assert_sanitized_request(@sanitizer, 'foo_bar_baz', 'ftp://foo_bar_baz')
      end
      
      test "it shouldn't care what kind of scheme is in the parameter" do
        assert_sanitized_request(@sanitizer, 'foo_bar_baz', 'taters://foo_bar_baz')
      end
      
      test "it should sanitize the scheme, even if the scheme is absent" do
        assert_sanitized_request(@sanitizer, 'foo_bar_baz', '://foo_bar_baz')
      end
    end
  end
end