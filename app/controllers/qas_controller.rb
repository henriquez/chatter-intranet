class QasController < ApplicationController


  # GET /qas (also mapped as domain root)
  # Display publisher and most recent questions from the group feed
  def index 
    @chatouts = Qa.get_group_feed(User.qa_app_user) # TODO need to set user from something.
  end


  # receive the form post from the browser and then post it to the Salesforce
  # group.  This is relay is necessary because we don't want to expose the access 
  # token on the form. That would let a clever user log into the org if they
  # knew how to use the token.
  def create
    uri = "/chatter/feeds/record/#{Qa::GROUP_ID}/feed-items"
    body = "from #{params[:name]} : #{params["text"]}"
    Session.do_post(User.qa_app_user, uri, body)
  rescue Session::PostTooLargeError => e
    flash.now[:error] = e.message
  ensure
    @chatouts = Qa.get_group_feed(User.qa_app_user) # get the feed
    render :action => 'index' # show the Q&A page again  
  end
  
end
