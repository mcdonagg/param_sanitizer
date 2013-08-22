require 'test_helper'
require 'rack/test'
require 'rack/utils'
require 'uri'

class Panatizer::IntegrationTest < Panatizer::TestCase
  include Rack::Test::Methods
  
  def dummy_app
    lambda { |env| [200, {}, [env["QUERY_STRING"]]] }
  end
  
  def app
    sanitized_routes = {
      '/a' => [Panatizer::Strategies::SpaceToDashStrategy],
      '/b' => [Panatizer::Strategies::StripPathStrategy],
      '/c' => [Panatizer::Strategies::StripSchemeStrategy],
      '/a/b' => [Panatizer::Strategies::SpaceToDashStrategy, Panatizer::Strategies::StripPathStrategy],
      '/a/c' => [Panatizer::Strategies::SpaceToDashStrategy, Panatizer::Strategies::StripSchemeStrategy]
    }
    Panatizer::RequestSanitizer.new(dummy_app, sanitized_routes)
  end
  
  def extract(msg)
    Rack::Utils.parse_nested_query(msg)
  end
  
  def uri_encoder(input)
    URI.encode(input)
  end
end