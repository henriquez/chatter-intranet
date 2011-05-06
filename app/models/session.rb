require 'httparty'

class Session 
  include HTTParty
  
  # .bashrc must have these set in the development environment
  # on use heroku config:add GITHUB_USERNAME=joesmith to set production values
  # see http://devcenter.heroku.com/articles/config-vars
  APP_DOMAIN = ENV['QA_DEMO_APP_DOMAIN']
  CLIENT_ID = ENV['QA_DEMO_KEY']
  CLIENT_SECRET = ENV['QA_DEMO_SECRET']
  SFDC_DOMAIN = ENV['QA_DEMO_LOGIN_URL']

  FORMAT = 'json'  # this is default
  
  # salesforce identity service endpoins - these don't change
  TOKEN_ENDPOINT = '/services/oauth2/token'
  AUTHORIZE_PATH = '/services/oauth2/authorize'
  

  
  # Given a refresh token, update that user with a fresh
  # access token.  Returns the refreshed user
  def self.get_new_token(user)
    uri = SFDC_DOMAIN + "/" + TOKEN_ENDPOINT
    options = { :body => { 'grant_type'     => 'refresh_token',
                           'refresh_token'  => user.refresh_token,
                           'client_id'      => CLIENT_ID,
                           'client_secret'  => CLIENT_SECRET,
                           'format'         => 'json' 
                          }
              }   
    Rails.logger.info "Getting refresh token..."    
    response = post(uri, options).response
    Rails.logger.info ">> status code was #{response.header.code}"
    Rails.logger.info ">>\n#{response.body.inspect}"
    response = Crack::JSON.parse(response.body)
    user.access_token = response['access_token']
    # note there is no new refresh token returned.
    user.save!
    user
  end
  
  
  # using identity service, return basic user info
  def self.get_user_identity(user)
    # SFDC issues a redirect, but httparty follows them by default
    response = do_get(user, user.identity_url)
    Crack::JSON.parse(response.body)  
  end
  
  
  # General purpose get with access token.
  def self.do_get(user, uri)
    base_uri "#{user.instance_url}/services/data/v22.0"
    options = { :headers => { 'Authorization'   => "OAuth #{user.access_token}",
                               'Content-Type'    => "application/json",
                               'X-PrettyPrint'   => "1"
                             }
               }
    get(uri, options).response 
  end  
  

  # body must be a Ruby hash, it will get form encoded.
  def self.do_post(user, uri, body)
    base_uri "#{user.instance_url}/services/data/v22.0"
    options = { :headers => { 'Authorization'   => "OAuth #{user.access_token}"
                             }
               }
    options.merge!( :body => body )             
    response = post(uri, options) 
    if response.header.code != "200" || response.header.code != "201"
        Rails.logger.error response.header.inspect
    end                
  end
  
end
