# not an ActiveRecord class because all the feed related data is stored
# in Salesforce.  This class just does the API calls to interact with 
# Salesforce. 
require 'uri'
 
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
  
 
  # search for feed items that match text and are parented by record_id, 
  # e.g. a specific group or record feed.
  def self.search_feed(user, record_id, text, page_size=100)
    escaped_text = URI.escape(text, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    items = Session.do_get(user, "/chatter/feed-items?q=#{escaped_text}&pageSize=#{page_size}")
    # filter out items that are not part of the searched group
    output = []
    items['items'].each do |item|
      output << item if item['parent']['id'] == record_id
    end
    output
  end
  
  
  # urls don't include the domain so we have to add it
  def self.complete_url(url)
     SFDC_DOMAIN + "/" + url
  end
  
  
  def self.get_members(user)
    resp = Session.do_get(user, "/chatter/groups/#{GROUP_ID}/members")
    # parse into a hash with key 'members' and array of names
    names = resp['members'].collect {|member| member['user']['name'] }
    names.to_json 
  end  
    
end
