# monkey patch Oauth2 gem to get at the params so that 
# user's identity url and instance url may be extracted
class OAuth2::AccessToken  
  attr_reader :params
end

class SessionsController < ApplicationController
  
  
  
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
    user = User.create_or_update_context_user(access_token)
    user.save_identity
    redirect_to user_path(user.id) # tell user they're authorized, 
    # then they can pick from a list of available apps.
  end
  
  
  private
  
  def client
    OAuth2::Client.new(
    Session::CLIENT_ID, 
    Session::CLIENT_SECRET, 
    :site => Session::SFDC_DOMAIN, 
    :authorize_path => Session::AUTHORIZE_PATH, 
    :access_token_path => Session::TOKEN_ENDPOINT
    )
  end
  
  # must match the callback url in the remote access application
  # exactly.
  def redirect_uri
    "https://#{Session::APP_DOMAIN}/sessions/callback"
  end
  
end
