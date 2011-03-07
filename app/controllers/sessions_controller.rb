class SessionsController < ApplicationController
  
  DOMAIN = 'localhost' # must match remote access app callback URI
  
  # Oauth Flow step 1
  # User clicks link to this method which in turns redirects
  # the browser to salesforce to authorize this app.
  def oauth
    redirect client.web_server.authorize_url(
    :response_type => 'code',
    :redirect_uri => "https://#{DOMAIN}/oauth/callback"
  )
  end
  
  
  # Oauth Flow step 3 (user authorization is step 2 at SFDC.com)
  # GET https://localhost/sessions/callback
  # SFDC redirects user to this after approval 
  def callback
    access_token = client.web_server.get_access_token(
      params[:code], 
      :redirect_uri => "https://#{request.host}/oauth/callback", 
      :grant_type => 'authorization_code'
      )
    # TODO: store access token and refresh token.
  end
  
  
  private
  
  def client
    OAuth2::Client.new(
    '3MVG9y6x0357HleefWmAEp6ZoEM5EsDYXpyugyMLCC6DxOpP7Dh8QFODKs.Q.bvR00UDmLULVojuSM8sPysA5', 
    '6687918166780982352', 
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
