require 'test_helper'
require 'rack/test'
require 'rack/utils'
require 'uri'

class ParamSanitizer::IntegrationTest < ParamSanitizer::TestCase
  include Rack::Test::Methods
  
  DEFAULT_ROUTES = {
    '/single' => [ParamSanitizer::Strategies::SpaceToDashStrategy],
    '/double' => [ParamSanitizer::Strategies::SpaceToDashStrategy, ParamSanitizer::Strategies::StripPathStrategy],
    '/breaking' => [ParamSanitizer::Strategies::StripPathStrategy, ParamSanitizer::Strategies::SpaceToDashStrategy]
  }
  
  def app
    ParamSanitizer::RequestSanitizer.new(dummy_app, DEFAULT_ROUTES)
  end
  
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