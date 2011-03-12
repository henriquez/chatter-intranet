class AppStoresController < ApplicationController
  # GET /app_stores
  # GET /app_stores.xml
  def index
    
    
  end

  # # GET /app_stores/1
  # # GET /app_stores/1.xml
  # def show
  #   @app_store = AppStore.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @app_store }
  #   end
  # end
  # 
  # # GET /app_stores/new
  # # GET /app_stores/new.xml
  # def new
  #   @app_store = AppStore.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @app_store }
  #   end
  # end
  # 
  # # GET /app_stores/1/edit
  # def edit
  #   @app_store = AppStore.find(params[:id])
  # end
  # 
  # # POST /app_stores
  # # POST /app_stores.xml
  # def create
  #   @app_store = AppStore.new(params[:app_store])
  # 
  #   respond_to do |format|
  #     if @app_store.save
  #       format.html { redirect_to(@app_store, :notice => 'App store was successfully created.') }
  #       format.xml  { render :xml => @app_store, :status => :created, :location => @app_store }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @app_store.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PUT /app_stores/1
  # # PUT /app_stores/1.xml
  # def update
  #   @app_store = AppStore.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @app_store.update_attributes(params[:app_store])
  #       format.html { redirect_to(@app_store, :notice => 'App store was successfully updated.') }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @app_store.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /app_stores/1
  # # DELETE /app_stores/1.xml
  # def destroy
  #   @app_store = AppStore.find(params[:id])
  #   @app_store.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(app_stores_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end
