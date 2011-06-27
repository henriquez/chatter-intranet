class QasController < ApplicationController



  def show
    user = User.qa_app_user
    @records = Qa.get_records(user) # populate the picker with all engines
    @selected_engine = params[:engine] ? params[:engine][:id].to_i : 0 # integer index to @records
    # always show the first engine in the picker's feed - second element is record id
    @chatouts = Qa.get_record_feed(user, @records[@selected_engine]['Id'] ) 
  end


  # receive the form post from the browser and then post it to the Salesforce
  # group.  This is relay is necessary because we don't want to expose the access 
  # token on the form. That would let a clever user log into the org if they
  # knew how to use the token.
  def create
    user = User.qa_app_user
    uri = "/chatter/feeds/record/#{ params[:engine_id] }/feed-items"
    body = "from #{params[:name]} : #{params["text"]}"
    response = Session.do_post(user, uri, body)
  rescue Session::PostTooLargeError => e
    flash.now[:error] = e.message
  ensure
    # save the question so we can notify user when its answered. Question.create :feed_item_id => feed_item_id, :comment_total => 0
    # Question.create! :feed_item_id => response['id'], 
    #                  :comment_total => 0,
    #                  :email => params[:email], 
    #                  :name => params[:name]
    @records = Qa.get_records(user) # populate the picker
    @selected_engine = params[:engine] ? params[:engine][:id].to_i : 0 # integer index
    @chatouts = Qa.get_record_feed(user, @records[@selected_engine]['Id'] )  # get the feed
    render :action => 'show' # show the Q&A page again  
  end
  
  
  # Ajax call when user clicks search button
  def search
    user = User.qa_app_user
    @chatouts = Qa.search_feed(user, params[:engine_id] , params[:search])
  end
  
    
  def sendmail
    user = User.new :email => 'logan@henriquez.net', :name => 'logan'
    reply = 'sent from dev environment'
    UserMailer.notification(user, reply).deliver
  end 
  
  
end
