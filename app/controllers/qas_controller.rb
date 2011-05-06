class QasController < ApplicationController


  # GET /qas (also mapped as domain root)
  # Display publisher and most recent questions from the group feed
  def index 
    @chatouts = Qa.get_group_feed(User.qa_app_user) # TODO need to set user from something.
  rescue Exception => e
    # if exception is due to bad token, do refresh token flow
    logger.error e
    flash.now[:notice] = e.message[0..200]
    logger.info "getting new token using refresh token"
    Session.get_new_token(User.qa_app_user) # saves new access token to user
    logger.info "got refresh token, getting feed"
    @chatouts = Qa.get_group_feed # gets access token from user
  end

end
