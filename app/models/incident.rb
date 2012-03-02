class Incident < ActiveRecord::Base
  include Shared::Geography
  include Kinds
  
  belongs_to :user
  belongs_to :bike_item
  
  validates_presence_of :coordinates, :kind, :description
  validates :vehicle_identifier, :format => /[A-Z0-9]{4}/, :allow_blank => true, :if => :accident_or_regulation_infraction?
  validates_presence_of :bike_description, :if => :theft_or_assault?
  
  def self.new_with(params, coordinates, user)
    user= user.nil? ? new(params) : new(params.merge(:user => user)) 
    user.apply_geo(coordinates)
    user
  end
  
  def self.date_filtering_options
    { 1 => :last_week, 2 => :last_month, 3 => :last_year, 4 => :all }
  end
  
  def self.date_filtering_option_for(option)
    self.date_filtering_options.invert[option]
  end
  
  def self.humanized_date_filtering_options
    self.date_filtering_options.keys.each.inject({}) do |collected, key| 
      collected[key] = humanized_date_filtering_option_for(key)
      collected
    end
  end
  
  def self.humanized_date_filtering_option_for(key)
    I18n.t("incidents.filtering.fields.date")[date_filtering_options[key]]
  end
  
  def self.filtering_with(params={})
    params = {} if params.eql?(:nothing)
    query=String.new
    values={}
    
    if params[:type]
      kinds_selected = params[:type].keys.each.inject(String.new) do |collected, last|
        collected += "#{Incident.kind_for(last.to_sym)},"
        collected
      end
      
      query += "kind IN (#{kinds_selected.chop})"
    end
    
    unless params[:complaint_issued].blank?
      query += " AND " unless query.blank?
      query += " complaint_issued = :complaint_issued"
      values.merge!({:complaint_issued =>  params[:complaint_issued] == "true" }) 
    end
    
    if end_date=range_date_for(params[:range_date])
      query += " AND " unless query.blank?
      query += " date_and_time >= :end_date"
      values.merge!({ :end_date => end_date })
    end
    
    if params[:map_enabled]
      polygon_given = self.make_polygon(params[:coordinates])
      unless polygon_given.nil?
        query += " AND " unless query.blank?
        query += "ST_Within(incidents.coordinates, ST_GeomFromEWKT(E'#{polygon_given.as_hex_ewkb}'))"
      end
    end
    
    categorized_by_kinds Incident.where(query, values)
  end
  
  def self.categorized_by_kinds(incidents=nil)
    (incidents || all).each.inject({:total => 0}) do |collected, incident| 
      collected[:total] += 1
      collected[incident.kind] ||= []
      collected[incident.kind] << incident
      collected
    end
  end
  
  def self.range_date_for(option)
    return false if(option.nil? || Incident.date_filtering_option_for(:all) == option)
    now = Time.now
    case option.to_i
    when Incident.date_filtering_option_for(:last_week)
      now-1.week
    when Incident.date_filtering_option_for(:last_month)
      now-1.month
    when Incident.date_filtering_option_for(:last_year)
      now-1.year
    end
  end
  
end
