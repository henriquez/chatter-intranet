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
  
  
  def self.context_user
    user = User.find_by_name('admin')
    if !user
      user = User.new 
      user.name = 'admin'
    end
    user  
  end
  
end
