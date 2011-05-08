# not an ActiveRecord class because all the feed related data is stored
# in Salesforce.  This class just does the API calls to interact with 
# Salesforce.  
class Qa 
  
  GROUP_ID = ENV['QA_DEMO_GROUP_ID']
          
  # Poll the org and write any new feed-items with the #chatout
  # tag to the db
  def self.get_group_feed(user)
    response = prepare_query("/chatter/feeds/record/#{GROUP_ID}/feed-items", user)
    Rails.logger.info response.inspect
    massage_output_for_view(response)
  end
  
    
  # doesn't display feed items that are tagged #private.  This lets questions
  # that a user doesn't want displayed to the world get placed into the group
  # but not redisplayed out to the world.  
  def self.massage_output_for_view(input)
    output = []
    input['items'].each do |item|
      next if item['body']['text'] =~ /#private/  # don't display private items
      output << item
    end
    output
  end
      
  
  # urls don't include the domain so we have to add it
  def self.complete_url(url)
     SFDC_DOMAIN + "/" + url
  end
  
  
  private
  
      # Generic response parser and error handler for gets
    def self.prepare_query(uri, user)
      Rails.logger.info "Getting uri=#{uri}"
      response = Session.do_get(user, uri)
      if response.header.code != "200"
        Rails.logger.error response.header.inspect
        # assume the token expired and try to refresh the token
        Rails.logger.info user.inspect
        user = Session.get_new_token(user)
        response = Session.do_get(user, uri)  
        raise StandardError, "status=#{response.header.code}, uri=#{uri}" if response.header.code != "200"        
      end 
      Crack::JSON.parse(response.body)  
    end
    
    
    
    
    
    
end
