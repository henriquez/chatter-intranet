require 'test_helper'

class SessionTest < ActiveSupport::TestCase

  
  test "get access token with refresh token" do
    refresh_token = ENV['refresh_token']
    user = User.create!(:name => 'admin', :refresh_token => refresh_token)
    Session.get_new_token(user)    
    assert_not_nil User.context_user.access_token 
  end
  
  
  test "post a feed item" do
    user = User.new :access_token => ENV['access_token'],
                    :instance_url => "https://prerelna1.pre.salesforce.com"
    uri = "/chatter/feeds/record/#{Qa::GROUP_ID}/feed-items"
    text = "a test"
    resp = Session.do_post(user, uri, text)
    puts resp['id']
    uri = "/chatter/feed-items/#{resp['id']}/comments"
    resp = Session.do_get(user, uri)
    puts resp.comments
  end
  
end