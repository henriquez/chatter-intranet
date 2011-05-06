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
    cookies[:app] = {
      :value => params[:app],
      :expires => 1.year.from_now,
      :domain => '/'
    }

    redirect_to client.web_server.authorize_url(
      :response_type => 'code',
      :redirect_uri => redirect_uri # this must match R.A. App so no params
    )
  end
  
  
  # Oauth Flow step 3 (user performing authorization is step 2 which occurs at SFDC.com)
  # GET https://#{app server domain}/sessions/callback
  # SFDC redirects user to this route after approval 
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
    user.save_identity unless user.name # get identity if not already there.
    # in case someone hits the oauth url and tries to auth a different user
    user.delete! unless user.user_name == 'qa_app@eeorg.net'
    redirect_to qas_path # display publisher and feed
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
  
  
  
  # must match the callback url in the remote access application exactly.
  def redirect_uri
    
    "https://#{Session::APP_DOMAIN}/sessions/callback"
  end
  
end
