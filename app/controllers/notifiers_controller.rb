class NotifiersController < ApplicationController
  
  # identify the user
  def index
    
  end

  # GET /notifiers/1
  # GET /notifiers/1.xml
  def show
    @notifier = Notifier.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @notifier }
    end
  end

  # GET /notifiers/new
  # GET /notifiers/new.xml
  def new
    @notifier = Notifier.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @notifier }
    end
  end

  # GET /notifiers/1/edit
  def edit
    @notifier = Notifier.find(params[:id])
  end

  # POST /notifiers
  # POST /notifiers.xml
  def create
    @notifier = Notifier.new(params[:notifier])

    respond_to do |format|
      if @notifier.save
        format.html { redirect_to(@notifier, :notice => 'Notifier was successfully created.') }
        format.xml  { render :xml => @notifier, :status => :created, :location => @notifier }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @notifier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notifiers/1
  # PUT /notifiers/1.xml
  def update
    @notifier = Notifier.find(params[:id])

    respond_to do |format|
      if @notifier.update_attributes(params[:notifier])
        format.html { redirect_to(@notifier, :notice => 'Notifier was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @notifier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notifiers/1
  # DELETE /notifiers/1.xml
  def destroy
    @notifier = Notifier.find(params[:id])
    @notifier.destroy

    respond_to do |format|
      format.html { redirect_to(notifiers_url) }
      format.xml  { head :ok }
    end
  end
end
