# not an ActiveRecord class because all the feed related data is stored
# in Salesforce.  This class just does the API calls to interact with 
# Salesforce.  
class Qa 
  
  GROUP_ID = ENV['QA_DEMO_GROUP_ID']
          
  # Poll the org and write any new feed-items with the #chatout
  # tag to the db
  def self.get_record_feed(user, record_id)
    response = Session.do_get(user, "/chatter/feeds/record/#{record_id}/feed-items")
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
      
  # return array of record objects for use in the picker and descriptions
  # returns array of array of record hashes with each attr as a key in the hash.
  # each key must begin with upper case letter.
  def self.get_records(user)
    response = Session.do_get(user, "/query/?q=SELECT+name+,+id+,+hertz__c+,+description__c+,+voltage__c+,+amps__c+from+Engine__c")
    response['records']  # array of record hashes
  end
  
 
  def self.search_feed(user, record_id, text)
    input = get_record_feed(user, record_id)
    # build array of feed items that match text
    # TODO: add comment text matching.
    output = []
    input.each do |item|
      output << item if item['body']['text'] =~ /#{text}/ 
    end
    output
  end
  
  
  # urls don't include the domain so we have to add it
  def self.complete_url(url)
     SFDC_DOMAIN + "/" + url
  end
  
  
    
end
