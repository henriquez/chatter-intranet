module QasHelper
  
  # Hack: puts in static images for known users to work around the lack of un-authenticated URLs
  # for static assets.
  def image_cheater(user_lastname)
    if user_lastname == 'User'
      image_tag("/images/pam.jpg", :size => "45x45", :class => 'profile-thumb' )
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
  
end
