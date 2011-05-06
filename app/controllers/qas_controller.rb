class QasController < ApplicationController


  # GET /qas (also mapped as domain root)
  # Display publisher and most recent questions from the group feed
  def index 
    return if !User.context_user.access_token # don't try to display feed
    # if we havent done oauth yet.  
    @chatouts = Chatout.get_news_feed(user) # TODO need to set user from something.
  rescue Exception => e
    # if exception is due to bad token, do refresh token flow
    logger.error e
    flash.now[:notice] = e.message[0..200]
    logger.info "getting new token using refresh token"
    Session.get_new_token(User.context_user) # saves new access token to user
    logger.info "got refresh token, getting feed"
    @chatouts = Chatout.get_feed # gets access token from user
  end

end
