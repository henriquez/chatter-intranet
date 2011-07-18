class QasController < ApplicationController

  # method to show the main (only) page
  def index
    user = User.qa_app_user
    @chatouts = Qa.get_record_feed(user, Qa::GROUP_ID ) 
  end


  # receive the form post from the browser and then post it to the Salesforce
  # group.  This is relay is necessary because we don't want to expose the access 
  # token on the form. That would let a clever user log into the org if they
  # knew how to use the token.
  def create
    user = User.qa_app_user
    uri = "/chatter/feeds/record/#{ Qa::GROUP_ID }/feed-items"
    body = params["text"]
    response = Session.do_post(user, uri, body)
  rescue Session::PostTooLargeError => e
    flash.now[:error] = e.message
  ensure
    # save the question so we can notify user when its answered. Question.create :feed_item_id => feed_item_id, :comment_total => 0
    # Question.create! :feed_item_id => response['id'], 
    #                  :comment_total => 0,
    #                  :email => params[:email], 
    #                  :name => params[:name]
    @chatouts = Qa.get_record_feed(user, Qa::GROUP_ID )  # get the feed
    render :action => 'index' # show the Q&A page again  
  end
  
  
  # Ajax call when user clicks search button
  def search
    user = User.qa_app_user
    @chatouts = Qa.search_feed(user, Qa::GROUP_ID , params[:search])
  end
  
  
  # Ajax call when user clicks team member list
  def team
    user = User.qa_app_user
    render :text => %({ "users": [
                                { "name" : "Patrick Dumfy", "link": "http://#{Session::APP_DOMAIN}/users?id=005A0000001rQP6", "photo" : "/images/patrick_thumb.png" },
                                { "name" : "Madison Rigby", "link": "http://#{Session::APP_DOMAIN}/users?id=005A0000001rQOr", "photo" : "/images/mrigby_thumb.png" }
                              ]
                      })        
  end  
  

  
    
  def sendmail
    user = User.new :email => 'logan@henriquez.net', :name => 'logan'
    reply = 'sent from dev environment'
    UserMailer.notification(user, reply).deliver
  end 
  
  
end
