require 'integration/test_helper'

class ParamSanitizer::ExecuteStrategyTest < ParamSanitizer::IntegrationTest  
  test "single strategy executes succesfuly" do
    assert_param("/single?sd=asd asd", 'sd', 'asd-asd')
  end
  
  test "multiple strategies execute succesfuly" do
    assert_param("/double?sd=asd asd/../../windows.ini", 'sd', '')
  end
  
  test "when a strategy sets a key to nil, subsequent strategies don't fail" do
    assert_param("/breaking?sd=asd asd/../../windows.ini", 'sd', '')
  end
  
  def assert_param(uri, key, value)
    last_response = get uri_encoder(uri)
    params = extract(last_response.body)
    assert_equal value, params[key]
  end  
end