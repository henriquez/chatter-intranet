class UsersController < ApplicationController
  
  def show
    user = User.qa_app_user
    @profile = Session.do_get(user, "/chatter/users/#{params[:id]}")
  end
  
  

end