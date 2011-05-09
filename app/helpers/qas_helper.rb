module QasHelper
  
  # puts in static images for known users to work around the lack of un-authenticated URLs
  # for static assets.
  def image_cheater(user_lastname)
    if user_lastname == 'Henriquez'
      image_tag("/images/henriquez_thumb.jpeg", :size => "45x45", :class => 'profile-thumb' )
      #return %{<img href="/images/henriquez_thumb.jpeg" width="45" height="45" class => "profile-thumb" > }
    elsif user_lastname == 'Houston' 
      return '<img href="/images/houston_thumb.jpeg" width="45" height="45" class => "profile-thumb" >' 
    end
  end
end
