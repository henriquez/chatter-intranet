class User < ActiveRecord::Base
  
  def create_or_update(access_token)
    user = User.find_by_name('admin')
    user = User.new if !user
    user.name = 'admin'
    user.instance_url = access_token.params['instance_url']
    user.refresh_token = access_token.refresh_token
    user.access_token = access_token.token
    user.identity_url = access_token.params['id']
    user.save!
  end  
  
end
