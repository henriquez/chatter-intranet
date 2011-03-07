# monkey patch Oauth2 gem to get at the params so that 
# user's identity url and instance url may be extracted
class OAuth2::AccessToken  
  attr_reader :params
end

class SessionsController < ApplicationController
  
  DOMAIN = 'lhenriquez-ltm' # must match remote access app callback URI
  CLIENT_SECRET = '6687918166780982352'
  CLIENT_ID = '3MVG9y6x0357HleefWmAEp6ZoEM5EsDYXpyugyMLCC6DxOpP7Dh8QFODKs.Q.bvR00UDmLULVojuSM8sPysA5'
  
  
  # Oauth Flow step 1
  # User clicks link to this method which in turns redirects
  # the browser to salesforce to authorize this app.
  def oauth
    redirect_to client.web_server.authorize_url(
    :response_type => 'code',
    :redirect_uri => redirect_uri
  )
  end
  
  
  # Oauth Flow step 3 (user authorization is step 2 at SFDC.com)
  # GET https://localhost/sessions/callback
  # SFDC redirects user to this after approval 
  def callback
    access_token = client.web_server.get_access_token(
      params[:code], 
      # below must be route to this method and same as the 
      # remote access app's url
      :redirect_uri => redirect_uri, 
      :grant_type => 'authorization_code'
      )
      # store these four in User and create new user if necessary
    User.create_or_update(access_token) 
    redirect_to root_path # send user to the status page
  end
  
  
  private
  
  def client
    OAuth2::Client.new(
    CLIENT_ID, 
    CLIENT_SECRET, 
    :site => 'https://login.salesforce.com', 
    :authorize_path =>'/services/oauth2/authorize', 
    :access_token_path => '/services/oauth2/token'
    )
  end
  
  # must match the callback url in the remote access application
  # exactly.
  def redirect_uri
    "https://#{DOMAIN}/sessions/callback"
  end
  
end
