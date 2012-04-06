module ApplicationHelper
  
  def provider_is?(provider)
    session["devise.oauth_data"][:provider].eql?(provider.to_s)
  end
  
  def errors_for(field, object)
    return "field-with-errors" unless object.errors[field].empty? 
  end
  
  def menu_section_for(section, namespace=nil)
    namespace = "#{namespace}_" if namespace
    p controller.controller_name
    selected = controller.controller_name=="#{section}" ? "selected" : ""
    out=content_tag(:p, link_to(t("app.sections.#{section}.title"), eval("#{namespace}#{section}_path")+"#/"), :class => selected)
    unless selected.blank?
      out += content_tag(:div, self.send("links_for_#{section}"), :class => "options")
    end
    out
  end
  
  def links_for_bikes
    out=  link_to(t('app.sections.bikes.subsections.new'), new_bike_path, current_action_matches?("new"))
    out+= link_to(t('app.sections.bikes.subsections.popular'), popular_bikes_path, current_action_matches?("popular"))
    #out+= link_to(t('app.sections.bikes.subsections.search'), search_bikes_path, class_selected.call("search"))
    out+= link_to(t('app.sections.bikes.subsections.mine'), mine_bikes_path, current_action_matches?("mine")) if user_signed_in?
    out
  end
  
  def links_for_incidents  
    out=  link_to(t('app.sections.incidents.subsections.new'), '#/new', :id => 'incidents-new')
    out+= link_to(t('app.sections.incidents.subsections.accidents'), '#/accidents', :id => 'incidents-accidents')
    out+= link_to(t('app.sections.incidents.subsections.stolen'), '#/thefts', :id => 'incidents-thefts') 
    out+= link_to(t('app.sections.incidents.subsections.assaults'), '#/assaults', :id => 'incidents-assaults') 
    out+= link_to(t('app.sections.incidents.subsections.regulation_infractions'), '#/regulation_infractions', :id => 'incidents-regulation_infractions') 
    out+= link_to(t('app.sections.incidents.subsections.search'), '#/search', :id => 'incidents-search')
    
    out
  end
  
  private
  def current_action_matches?(action)
    {:class => "selected"} if action == controller.action_name
  end
end
