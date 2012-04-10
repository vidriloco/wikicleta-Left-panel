module BikesHelper
  
  def tooltip_for(bike)
    if user_signed_in?
      return t('bikes.views.show.likes.do') if bike.is_liked_by?(current_user).eql?("weak")
      t('bikes.views.show.likes.undo')
    else
      t('bikes.views.show.likes.required_to_login')
    end
  end
  
  def contact_for(bike)
    link_to(bike.owner, 'javascript:void(0);', 'original-title' => bike.contact, :class => 'contact')
  end

end