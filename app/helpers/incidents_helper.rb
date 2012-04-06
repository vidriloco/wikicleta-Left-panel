module IncidentsHelper
  
  def incident_types_for(incidents)
    incidents = [incidents] if incidents.is_a?(Symbol)
    with_incidents = incidents.each.inject("incident-selectable") do |collected,incident|
      collected += " incident-#{Bike.category_for(:incidents, incident)}"
      collected
    end
  end
  
  def current_user_has_bikes_to_report?
    return false unless user_signed_in?
    !current_user.bikes.empty?
  end
  
  def incidents_for_session_status
    if current_user_has_bikes_to_report?
      Bike.humanized_categories_for(:incidents).invert
    else
      Bike.humanized_categories_for(:incidents, :except => [:theft, :assault, :accident]).invert
    end
  end
  
  def partial_numbers_for(ocurrences, kind)
    count = ocurrences == nil ? 0 : ocurrences.count
    text = count == 1 ? t("incidents.views.index.numbers.#{kind}.one") : t("incidents.views.index.numbers.#{kind}.other")
    result = "<a href='#/#{kind.to_s.pluralize}' class='group-toggle' id='#{kind}'>
    <span class='number'>#{count}</span><span class='text'>#{text}</span>
    </a>"    
    result.html_safe
  end
  
  def reporter_of(incident)
    if incident.user.nil?
      t('incidents.views.index.list.item.reporter.anonymous')
    else
      t('incidents.views.index.list.item.reporter.user', :user => incident.user.username)
    end
  end
end
