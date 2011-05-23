module QasHelper
  
  # puts in static images for known users to work around the lack of un-authenticated URLs
  # for static assets.
  def image_cheater(user_lastname)
    if true
    # if user_lastname == 'Henriquez'
      image_tag("/images/henriquez_thumb.jpeg", :size => "45x45", :class => 'profile-thumb' )
      #return %{<img href="/images/henriquez_thumb.jpeg" width="45" height="45" class => "profile-thumb" > }
    elsif user_lastname == 'Houston' 
      image_tag("/images/houston_thumb.jpeg", :size => "45x45", :class => 'profile-thumb' )
    elseif user_lastname == 'Cook'
      image_tag("/images/houston_thumb.jpeg", :size => "45x45", :class => 'profile-thumb' )
    elseif user_lastname == 'Cutter'
      image_tag("/images/cutter_thumb.jpeg", :size => "45x45", :class => 'profile-thumb' )
    elseif user_lastname == 'Chadraa'
      image_tag("/images/chadraa_thumb.jpeg", :size => "45x45", :class => 'profile-thumb' )  
    end
  end
end
