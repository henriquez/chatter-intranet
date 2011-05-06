class User < ActiveRecord::Base
  
  # will create a new user and save their access token and other info
  # whenever anyone initiates the oauth process.
  def self.create_or_update_context_user(access_token)
    user = User.find_by_identity_url(access_token.params['id'])
    user = User.new if !user  
    user.instance_url = access_token.params['instance_url']
    user.refresh_token = access_token.refresh_token
    user.access_token = access_token.token
    user.identity_url = access_token.params['id']
    user.save!
    user
  end  
  
  
  def save_identity
    id = Session.get_user_identity(self)
    logger.info id.inspect
    self.name = id['display_name']
    self.organization_id = id['organization_id']
    self.user_name = id['username']
    self.user_id = id['user_id']
    self.profile_thumbnail_url = id['photos']['thumbnail']
    self.email = id['email']
    self.save!
  end
  
      
  
end
