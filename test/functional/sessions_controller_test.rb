require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  # get /session/oauth by manually typing it in, 
  # assert app saves access token to db
  # NB: test doesn't work because the textmate test env assumes you're redirecting
  # against test.host instead of the APP_DOMAIN set in the rails env- it never hits
  # the real running server.  ONLY works manually
  test "get access token using Oauth" do
    get "oauth"
    assert_redirected_to "https://na1-blitz01.soma.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9PhR6g6B7ps4dYH40OOCrbHas5leh_dtM7VN9xQs0oB35nuhQ.1lVAjrnD_duieHRnMDpB223j0rAsKbb&type=web_server&redirect_uri=https%3A%2F%2F172.16.141.1%2Fsessions%2Fcallback"
  end
  
end
