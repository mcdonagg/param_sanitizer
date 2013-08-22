require 'test_helper'

module Panatizer
  module Strategies
    class StripPathStrategyTest < Panatizer::UnitTest
      def setup
        @sanitizer = StripPathStrategy.new
      end
      
      test "it should not convert a request that doesn't contain a path" do
        assert_sanitized_request(@sanitizer, 'foo_bar_baz', 'foo_bar_baz')
      end
      
      test "it should set the param to nil if the request contains a path" do
        assert_sanitized_request(@sanitizer, nil, '../../../../../../mysql.conf')
      end
      
      test "it should set the param to nil if the request contains a windows-style file path" do
        assert_sanitized_request(@sanitizer, nil, '..\..\..\..\..\windows.ini')
      end
      
      test "it should set the param to nil if the request contains HTML-like text" do
        assert_sanitized_request(@sanitizer, nil, '%28%29%26%25<ScRiPt>prompt(23424324)</ScRiPt>')
      end
    end
  end
end