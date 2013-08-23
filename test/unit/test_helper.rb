require 'test_helper'

class ParamSanitizer::UnitTest < ParamSanitizer::TestCase
  
  def app(sanitizer, expectation)
    lambda { |env|
      request = Rack::Request.new(env)
      sanitizer.call(request)
      assert_equal expectation, request.params['query']
      [200, {'Content-Type' => 'text/plain'}, ['Hello World']] 
    }
  end
  
  def assert_sanitized_request(sanitizer, expected, query)
    Rack::MockRequest.new(app(sanitizer, expected)).get('/', 'QUERY_STRING' => "query=#{query}")
  end
end