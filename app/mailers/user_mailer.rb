class UserMailer < ActionMailer::Base
  default :from => "noreply@ask-api.heroku.com"
  
  def notification(user, reply)
    @user = user
    @url  = "http://ask-api.heroku.com"
    @reply = reply
    mail( :to => user.email,
          :subject => "The Chatter API team responded to your question")
  end
end
