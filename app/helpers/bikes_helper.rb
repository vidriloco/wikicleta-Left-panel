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
  
  def sharing_for(bike)
    return if bike.bike_statuses.empty?
    
    sharing_block="<ul class='social-status'>"
    bike.bike_statuses.each do |bike_status|
      available_msg = t('bike_statuses.views.preview.available')[bike_status.availability]
      link = link_to(Bike.humanized_category_for(:statuses, bike_status.concept), 'javascript:void(0);', 'original-title' => available_msg, :class => 'contact')
      sharing_block += "<li>#{link}</li>"
    end
    
    sharing_block+="</ul>"
    sharing_block.html_safe
  end
  
  def details_for(bike)
    out = "<p class='kind'>#{Bike.humanized_category_for(:types, bike.kind)}</p><p class='brand'>#{bike.brand}</p>"
    out += link_to(t('bikes.views.show.photos.show'), 'javascript:void(0);', :class => 'open-gallery') unless bike.pictures.empty?
    out += link_to("", 'javascript:void(0);', :class => 'reveals-picture-manager') if user_signed_in?
    out.html_safe
  end

  def current_user_owns_bike?(bike)
    user_signed_in? && current_user.owns_bike?(bike)
  end
  
  def cost_for_bike_rent(attribute, bike_status)
    if cost=bike_status.send(attribute) 
      "<span class='value #{attribute}' original-title='#{t("bike_statuses.views.index.rent.#{attribute}")}'>$ #{cost} MXN</span>".html_safe 
    end
  end
  
  def bike_price(bike_status)
    if price=bike_status.send(:price) 
      "<span class='value'>$ #{price} MXN</span>".html_safe 
    end
  end
end