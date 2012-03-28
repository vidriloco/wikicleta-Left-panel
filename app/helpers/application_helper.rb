module ApplicationHelper
  
  def provider_is?(provider)
    session["devise.oauth_data"][:provider].eql?(provider.to_s)
  end
  
  def errors_for(field, object)
    return "field-with-errors" unless object.errors[field].empty? 
  end
  
  def menu_section_for(section)
    selected = controller.controller_name==section.to_s ? "selected" : ""
    out=content_tag(:p, link_to(t("app.sections.#{section.to_s}.title"), eval("#{section.to_s}_path")), :class => selected)
    unless selected.blank?
      out += content_tag(:div, links_for_bikes, :class => "options") if section.eql?(:bikes)
    end
    out
  end
  
  def links_for_bikes
    class_selected = lambda do |action| 
      {:class => "selected"} if action == controller.action_name
    end    
    out=  link_to(t('app.sections.bikes.subsections.new'), new_bike_path, class_selected.call("new"))
    out+= link_to(t('app.sections.bikes.subsections.popular'), popular_bikes_path, class_selected.call("popular"))
    out+= link_to(t('app.sections.bikes.subsections.search'), search_bikes_path, class_selected.call("search"))
  end
end
