class NotifiersController < ApplicationController
  
  def show
    @task = "Build a demo of an app that drops in notifications by #{Time.now}"
  end
  
end
