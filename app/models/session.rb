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
  VERSION = "v22.0" # Winter '11 release
  
  CA_CERT_FILE = '/usr/lib/ssl/certs/ca-certificates.crt' # on heroku
  # note that dev ignores cert verification
  
  FORMAT = 'json'  # this is default, can also be 'xml'
  
  # salesforce identity service endpoints
  TOKEN_ENDPOINT = '/services/oauth2/token'
  AUTHORIZE_PATH = '/services/oauth2/authorize'
  
  class PostTooLargeError < StandardError; end
  
  
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
    if response.header.code != "200"
      raise StandardError, "Error: Failed on refresh token retry: status=#{response.header.code}, uri=#{uri}" 
    else
      Rails.logger.info "..got refresh token"
    end  
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
  
  
  
  # General purpose get with error handling and retry for expired token
  def self.do_get(user, uri, file, filename)
    Rails.logger.info "Getting uri=#{uri}"
    base_uri "#{user.instance_url}/services/data/#{VERSION}"
    options = { :headers => { 'Authorization'   => "OAuth #{user.access_token}",
                               'Content-Type'    => "application/json",
                               'X-PrettyPrint'   => "1"
                             }
               }
    response = get(uri, options).response 
    if response.header.code == "401" 
      # if exception is due to bad token(401), do refresh token flow
      user = User.qa_app_user # get the user-as-application
      get_new_token(user) # saves new access token to user
      options = { :headers => { 'Authorization'   => "OAuth #{user.access_token}",
                               'Content-Type'    => "application/json",
                               'X-PrettyPrint'   => "1"
                             }
               } # populate options with new access token
      response = get(uri, options).response # redo the request
    elsif response.header.code != '200' # failed for some other reason
      raise StandardError, "unknown failure getting uri with #{response.header.inspect}"
    end
    Crack::JSON.parse(response.body)  
  end  
  
  
  
  
  # General purpose post with error handling and retry for expired token
  # text is a string, it will get form encoded downstream
  def self.do_post(user, uri, text)
    raise PostTooLargeError, "Post may not exceed 1000 characters" if text.length > 1000
    Rails.logger.info "Posting uri=#{uri}"
    base_uri "#{user.instance_url}/services/data/#{VERSION}"
    options = { :headers => { 'Authorization'   => "OAuth #{user.access_token}"
                             }
               }
    options.merge!( :body => { :text => text } )          
    response = post(uri, options) 
    
    if response.header.code == "401" 
      # if exception is due to bad token(401), do refresh token flow
      user = User.qa_app_user # get the user-as-application
      get_new_token(user) # saves new access token to user
      options = { :headers => { 'Authorization'   => "OAuth #{user.access_token}",
                               'Content-Type'    => "application/json",
                               'X-PrettyPrint'   => "1"
                             }
               } # populate options with new access token
      response = post(uri, options) # redo the request
    elsif response.header.code != '201' # failed for some other reason
      raise StandardError, "unknown failure getting uri with #{response.header.inspect}"
    end
    
    Crack::JSON.parse(response.body)               
  end
  
end
