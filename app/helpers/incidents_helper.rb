module IncidentsHelper
  
  def total_numbers_for(ocurrences)
    count = ocurrences.values.each.inject(0) { |accum, val| accum += val; accum }
    return t('incidents.index.numbers.total.one') if count == 1
    t('incidents.index.numbers.total.other', :count => count)
  end
  
  def partial_numbers_for(ocurrences, kind, as_link=false)
    text=status_numbers_for(ocurrences, kind)
    result = as_link ? link_to(text, 'javascript:void(0);', :id => "#{kind}", :class => "group-toggle") : "<span class='#{kind}'>#{text}</span>"
    result.html_safe
  end
  
  def status_numbers_for(ocurrences, kind)
    count = ocurrences[Incident.kind_for(kind)] || 0
    count == 1 ? t("incidents.index.numbers.#{kind}.one") : t("incidents.index.numbers.#{kind}.other", :count => count)
  end
  
  def incident_types_for(incidents)
    incidents = [incidents] if incidents.is_a?(Symbol)
    with_incidents = incidents.each.inject(String.new) do |collected,incident|
      collected += " incident-#{Incident.kind_for(incident)}"
      collected
    end
    "#{with_incidents} incident-selectable"
  end
    
  def is_visible(incidents, object)
    incidents = [incidents] if incidents.is_a?(Symbol)
    incidents.each do |incident|
      return if Incident.kind_for(incident) == object.kind
    end
    "hidden"
  end 
  
  def reporter_of(incident)
    if incident.user.nil?
      t('incidents.index.list.item.reporter.anonymous')
    else
      t('incidents.index.list.item.reporter.user', :user => incident.user.username)
    end
  end
end
