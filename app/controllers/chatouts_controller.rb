class ChatoutsController < ApplicationController


  # GET /chatouts
  # Display chats with #chatout hashtag
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


  def old
  end  



  # # GET /chatouts/1
  # # GET /chatouts/1.xml
  # def show
  #   @chatout = Chatout.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @chatout }
  #   end
  # end
  # 
  # # GET /chatouts/new
  # # GET /chatouts/new.xml
  # def new
  #   @chatout = Chatout.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @chatout }
  #   end
  # end
  # 
  # # GET /chatouts/1/edit
  # def edit
  #   @chatout = Chatout.find(params[:id])
  # end
  # 
  # # POST /chatouts
  # # POST /chatouts.xml
  # def create
  #   @chatout = Chatout.new(params[:chatout])
  # 
  #   respond_to do |format|
  #     if @chatout.save
  #       format.html { redirect_to(@chatout, :notice => 'Chatout was successfully created.') }
  #       format.xml  { render :xml => @chatout, :status => :created, :location => @chatout }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @chatout.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PUT /chatouts/1
  # # PUT /chatouts/1.xml
  # def update
  #   @chatout = Chatout.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @chatout.update_attributes(params[:chatout])
  #       format.html { redirect_to(@chatout, :notice => 'Chatout was successfully updated.') }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @chatout.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /chatouts/1
  # # DELETE /chatouts/1.xml
  # def destroy
  #   @chatout = Chatout.find(params[:id])
  #   @chatout.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(chatouts_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end
