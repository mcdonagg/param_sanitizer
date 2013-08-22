require 'integration/test_helper'

class Panatizer::RequestSanitizerIntegrationTest < Panatizer::IntegrationTest
  def test_redirect_logged_in_users_to_dashboard
    last_response = get uri_encoder("/a?sd=asd asd")
    params = extract(last_response.body)
    assert_equal 'asd-asd', params['sd']
  end
end