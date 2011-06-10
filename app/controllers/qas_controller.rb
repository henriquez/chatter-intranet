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
    response = Session.do_post(User.qa_app_user, uri, body)
  rescue Session::PostTooLargeError => e
    flash.now[:error] = e.message
  ensure
    # save the question so we can notify user when its answered. Question.create :feed_item_id => feed_item_id, :comment_total => 0
    # Question.create! :feed_item_id => response['id'], 
    #                  :comment_total => 0,
    #                  :email => params[:email], 
    #                  :name => params[:name]
    @chatouts = Qa.get_group_feed(User.qa_app_user) # get the feed
    render :action => 'index' # show the Q&A page again  
  end
  
  
  def sendmail
    user = User.new :email => 'logan@henriquez.net', :name => 'logan'
    reply = 'sent from dev environment'
    UserMailer.notification(user, reply).deliver
  end 
  
  
end
