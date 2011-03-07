require 'httparty'

class Chatout < ActiveRecord::Base
  include HTTParty
  DOMAIN = "https://na1-blitz01.soma.salesforce.com"
  base_uri "#{DOMAIN}/services/data/v22.0/chatter"
  
  TEST = { 'items' => [{
              'rawBody' => 'the service is back up! #servicestatus',
              'user' => { 'photoUrl' => '/images/chatty.png',
                          'name' => 'Fred Flintstone',
                          'url' => 'http://google.com' },
              'body' => 'the service is back up! #servicestatus',
              'createdDate' => '2011-03-06T17:26:20.000Z',
              'comments' => {
                  'total' => 2,
                  'comments' => [
                    { 'id' => '0D7000000005f0AA',
                      'user' => { 'photoUrl' => '/images/chatty.png',
                          'name' => 'Fred Flintstone',
                          'url' => 'http://google.com' },
                      'url' => '/services/data/v22.0/chatter/comments/xxx',
                      'body' => 'we found a fly in a circuit board',
                      'createdDate' => '2011-03-06T14:45:20.000Z' 
                    },
                    { 'id' => '0D7000000005f0BB',
                      'user' => { 'photoUrl' => '/images/rails.png',
                          'name' => 'Dino Dinosaur',
                          'url' => 'http://google.com' },
                      'url' => '/services/data/v22.0/chatter/comments/xxx',
                      'body' => 'Damn you fly!',
                      'createdDate' => '2011-03-06T14:45:20.000Z' 
                    }            
                  ]
                }  
              },
              {
              'rawBody' => 'the service will be down for about an hour today while we fix the database. Were very sorry for this interrruption. #servicestatus',
              'user' => { 'photoUrl' => '/images/chatty.png',
                          'name' => 'Fred Flintstone',
                          'url' => 'http://google.com' },
              'body' => 'the service will be down for about an hour today while we fix the database. We apologize for the downtime, but it couldnt be helped. There ipso facto  We apologize for the downtime, but it couldnt be helped.  #servicestatus',
              'createdDate' => '2011-03-06T14:45:20.000Z',
              'comments' => {
                  'total' => 2,
                  'comments' => [],
                }
              }  
            ]  
          }
          
  # Poll the org and write any new feed-items with the #chatout
  # tag to the db
  def self.poll
    response = TEST #do_get('/feeds/news/005D0000001GMWE/feed-items')
    extract_chatout_items(response)
  end
  
  
  # return array of items  with #chatout
  def self.extract_chatout_items(input)
    output = []
    input['items'].each do |item|
      next unless item['rawBody'] =~ /#servicestatus/
      # addressing bugs in returned URLs:
      # link to user profile doesn't include domain
      item['user']['url'] = DOMAIN + "/" + item['user']['url']
      # strip the hashtag out of the item
      item['body'].gsub!(/#servicestatus/, '')
      item['createdDate'] = DateTime.parse(item['createdDate'])
      output << item 
    end
    output
  end
  
  
  private
  
      # Generic response parser and error handler for gets
    def self.do_get(uri)
      token = Session.token
      #token = '00DD0000000FPIV!AQ4AQGVqSzSXGLf3ZHFsDOawo.8QmzimR2J1eeRHiJsjIgF9CUSqKWFjBxx801GMl3bVyiYwr0zZ84Pp0C3EjO833s77V5lk'
      options = { :headers => { 'Authorization'   => "OAuth #{token}",
                                 'Content-Type'    => "application/json",
                                 'X-PrettyPrint'   => "1"
                               }
                 }
      logger.info options
      logger.info uri
        response = get(uri, options).response 
      raise StandardError, "status=#{response.header.code}" if response.header.code != "200"
      Crack::JSON.parse(response.body)
    end
end
