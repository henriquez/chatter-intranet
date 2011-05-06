# not an ActiveRecord class because all the feed related data is stored
# in Salesforce.  This class just does the API calls to interact with 
# Salesforce.  
class Qa 
  
          
  # Poll the org and write any new feed-items with the #chatout
  # tag to the db
  def self.get_service_status_feed(user) 
    response = prepare_query("/chatter/feeds/news/#{user.user_id}/feed-items", user)
    extract_chatout_items(response)
  end
  
  
  def self.get_news_feed(user)
    prepare_query("/chatter/feeds/news/#{user.user_id}/feed-items", user)
  end
    
  
  # return array of items  with #chatout
  def self.extract_chatout_items(input)
    output = []
    input['items'].each do |item|
      next unless item['rawBody'] =~ /#servicestatus/
      # addressing bugs in returned URLs:
      # link to user profile doesn't include domain
      item['user']['url'] = SFDC_DOMAIN + "/" + item['user']['url']
      # strip the hashtag out of the item
      item['body'].gsub!(/#servicestatus/, '')
      logger.info item['createdDate'].class
      output << item 
    end
    output
  end
  
  
  private
  
      # Generic response parser and error handler for gets
    def self.prepare_query(uri, user)
      logger.info "Getting uri=#{uri}"
      response = Session.do_get(user, uri)
      if response.header.code != "200"
        logger.error response.header.inspect
        # assume the token expired and try to refresh the token
        logger.info user.inspect
        user = Session.get_new_token(user)
        response = Session.do_get(user, uri)  
        raise StandardError, "status=#{response.header.code}, uri=#{uri}" if response.header.code != "200"        
      end 
      Crack::JSON.parse(response.body)  
    end
    
    
    
    
    
    
end
