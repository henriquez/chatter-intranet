class Notifier < ActiveRecord::Base
  
  def self.notify(user)
    uri = "/chatter/feeds/news/me/feed-items"
    body = { 'text' =>  "Its #{Time.now}.  Time for a break!" }
    Session.do_post(user, uri, body)
  end
  
end
