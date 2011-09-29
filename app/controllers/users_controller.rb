class UsersController < ApplicationController
  
  def show
    user = User.qa_app_user
    @profile = Session.do_get(user, "/chatter/users/#{params[:id]}")
    Rails.logger.info @profile.inspect
    # DEPLOY remove above logger
  end
  
  

end