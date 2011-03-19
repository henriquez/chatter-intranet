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

    logger.info "params >>>>>>>>>"
    logger.info cookies[:app]
    redirect_to client.web_server.authorize_url(
    :response_type => 'code',
    :redirect_uri => redirect_uri # this must match R.A. App so no params
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
    cookies.permanent[:user_id] = user.id
    
    user.save_identity unless user.name # get identity if not already there.
    # redirect to a controller based on which application the user
    # clicked on the app-stores index page
    logger.info "cookies>>>>>>"
    logger.info cookies[:app]
    #redirect_to eval(cookies[:app] + '_path(user.id)')
    redirect_to notifier_path(user.id)  
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
