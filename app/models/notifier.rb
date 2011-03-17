class Notifier < ActiveRecord::Base
  
  def self.notify(user)
    uri = "/chatter/feeds/news/me/feed-items"
    body = { 'text' =>  "has the 'build a demo' task due today. \
      For more detail about the task see http://#{Session::APP_DOMAIN}/notifiers/3 ",
             'url' => "http://#{Session::APP_DOMAIN}/notifiers/welcome",
             'urlName' => "Click here to start using the Acme Task Manager App" }
    Session.do_post(user, uri, body)
  end
  
end
