require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "get access token with refresh token" do
    refresh_token = "5Aep861rEpScxnNE666kY9KXIYdryKLB.sTUR3sJVeGbBhC3FCJ7YSGC4WiyKc6wJmB0nMHw7ntag=="
    user = User.create!(:name => 'admin', :refresh_token => refresh_token)
    Session.get_new_token(user)    
    assert_not_nil User.context_user.access_token 
  end
end
