require 'httparty'

class Session 
  include HTTParty
  
  # App and remote app definition settings
  APP_DOMAIN = 'lhenriquez-ltm' # must match remote access app callback URI
  CLIENT_SECRET = '6687918166780982352'
  CLIENT_ID = '3MVG9y6x0357HleefWmAEp6ZoEM5EsDYXpyugyMLCC6DxOpP7Dh8QFODKs.Q.bvR00UDmLULVojuSM8sPysA5'
  FORMAT = 'json'  # this is default
  
  # salesforce environment settings
  TOKEN_ENDPOINT = '/services/oauth2/token'
  AUTHORIZE_PATH = '/services/oauth2/authorize'
  SFDC_DOMAIN = 'https://login.salesforce.com'   #"https://na1-blitz01.soma.salesforce.com"
  base_uri "#{SFDC_DOMAIN}/services/data/v22.0/chatter"
  
  
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
  
  
  # General purpose get with access token.
  def self.do_get(user, uri)
    options = { :headers => { 'Authorization'   => "OAuth #{user.access_token}",
                               'Content-Type'    => "application/json",
                               'X-PrettyPrint'   => "1"
                             }
               }
    get(uri, options).response 
  end  

end
