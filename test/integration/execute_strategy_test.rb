require 'integration/test_helper'

class ParamSanitizer::ExecuteStrategyTest < ParamSanitizer::IntegrationTest
  DEFAULT_ROUTES = {
    '/single' => [ParamSanitizer::Strategies::SpaceToDashStrategy],
    '/double' => [ParamSanitizer::Strategies::SpaceToDashStrategy, ParamSanitizer::Strategies::StripPathStrategy]
  }
  
  def teardown
    @strategized_routes = nil
  end
  
  def strategized_routes
    @strategized_routes || DEFAULT_ROUTES
  end
  
  def app
    ParamSanitizer::RequestSanitizer.new(dummy_app, strategized_routes)
  end
  
  test "single strategy executes succesfuly" do
    last_response = get uri_encoder("/single?sd=asd asd")
    params = extract(last_response.body)
    assert_equal 'asd-asd', params['sd']
  end
  
  test "multiple strategies execute succesfuly" do
    last_response = get uri_encoder("/double?sd=asd asd/../../windows.ini")
    params = extract(last_response.body)
    assert_equal "", params['sd']
  end
  
  test "when a strategy sets a key to nil, subsequent strategies don't fail" do
    @strategized_routes = {
      '/breaking' => [ParamSanitizer::Strategies::StripPathStrategy, ParamSanitizer::Strategies::SpaceToDashStrategy]
    }
    
    last_response = get uri_encoder("/breaking?sd=asd asd/../../windows.ini")
    params = extract(last_response.body)
    assert_equal "", params['sd']
  end
  
end