# Plan
#  1. when user asks a question its posted as a feed item and as a question 
#     in the db.  the question has a feed item id in it that we save 
#     that comes with the 201 response that we save to the record for polling 
#     purposes.  We set the comment count to zero.
#  2. every hour the cron job polls the questions table locally looking for question
#     record.  If it finds one it uses the feed item id to pull the feed item using
#     the feed item resource.  This also returns all the comments on that feed item,
#     so if there are >1 comments and the comment count on the questions table
#     is < the number of comments we send an email to the posting user.
#  3. if an email is sent to the posting user, we 
#        * increment the comment count so we don't notify again unless there's a new
#          comment   

desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Time.now.minute % 59 == 0 # run every hour
    puts "Updating feed..."
    NewsFeed.update
    puts "done."
  end

end