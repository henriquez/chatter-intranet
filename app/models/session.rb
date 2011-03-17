require 'httparty'

class Session 
  include HTTParty
  
  # pick an environment listed in sfdc_config.yml
  sfdc_env = 'blitz01' # set this based on keys in sfdc_config
  sfdc = YAML.load(File.read(File.expand_path('../../../config/sfdc_config.yml', __FILE__)))
  APP_DOMAIN = sfdc[sfdc_env]['app_domain']
  CLIENT_ID = sfdc[sfdc_env]['client_id']
  CLIENT_SECRET = sfdc[sfdc_env]['client_secret']
  SFDC_DOMAIN = sfdc[sfdc_env]['sfdc_domain']

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
