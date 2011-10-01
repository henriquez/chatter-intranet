require 'uri'

module QasHelper
  
  # Hack: puts in static images for known users to work around the lack of un-authenticated URLs
  # for static assets.
  def image_cheater(user_lastname)
    if user_lastname == 'User'
      image_tag("/images/demouser_thumb.jpg", :size => "45x45", :class => 'profile-thumb' )
    elsif user_lastname == 'Rigby'
      image_tag("/images/mrigby_thumb.png", :size => "45x45", :class => 'profile-thumb' )
    elsif user_lastname == 'Dumfy'
      image_tag("/images/patrick_thumb.png", :size => "45x45", :class => 'profile-thumb' )
    elsif user_lastname == 'Smith'
      image_tag("/images/john_smith_thumb.png", :size => "45x45", :class => 'profile-thumb' )

    end
  end
  
  
  # formats into picker select format
  def records_for_picker(records)
    ret = []
    records.each_with_index do |record, i| 
      ret << [record['Name'], i ] 
    end
    ret
  end
  
  
  # helper that takes a feedItem hash and converts it to HTML, including
  # properly structuring any included message segments like @mentions.
  def message_segments(feeditem)
    # an array of hashes - each hash a segment
    html = ''
    feeditem['body']['messageSegments'].each do |segment|
      html << case segment['type']
               when 'Text'
                 segment['text']
               when 'Link'
                 %Q(<a href="#{segment['url']}">#{segment['text']}</a>)
               when 'Mention'
                 %Q(<a href="/users/#{segment['user']['id']}">#{segment['text']}</a>)
               when 'Hashtag' 
                 %Q(<a class="hashtag">#{segment['text']}</a>)
               else
                 # other types are tracked changes, we don't include these.
               end                  
    end 
    html 
  end
  
end
