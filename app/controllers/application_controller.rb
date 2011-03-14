class ApplicationController < ActionController::Base
  protect_from_forgery
  
  @@current_user = nil
  
  def current_user=(user)
    @@current_user =  user
  end
  
  def current_user
    @@current_user
  end
    
end
