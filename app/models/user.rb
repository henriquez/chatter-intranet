class User < ActiveRecord::Base
  
  def self.create_or_update_context_user(access_token)
    user = User.context_user
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
    self.save!
  end
  
  def self.context_user
    user = User.find_by_name('admin')
    if !user
      user = User.new 
      user.name = 'admin'
    end
    user  
  end
  
end
