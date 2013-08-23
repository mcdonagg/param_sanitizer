require 'test_helper'
require 'rack/test'
require 'rack/utils'
require 'uri'

class ParamSanitizer::IntegrationTest < ParamSanitizer::TestCase
  include Rack::Test::Methods
  
  def dummy_app
    lambda { |env| [200, {}, [env["QUERY_STRING"]]] }
  end
  
  def extract(msg)
    Rack::Utils.parse_nested_query(msg)
  end
  
  def uri_encoder(input)
    URI.encode(input)
  end
end