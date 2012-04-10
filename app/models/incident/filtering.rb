module Incident::Filtering
  
  module ClassMethods
    def date_filtering_options
      { 1 => :last_week, 2 => :last_month, 3 => :last_year, 4 => :all }
    end

    def date_filtering_option_for(option)
      self.date_filtering_options.invert[option]
    end
    
    def range_date_for(option)
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
    
    def filtering_with(params={})
      params = {} if params.eql?(:nothing)
      query=String.new
      values={}

      if params[:type]
        kinds_selected = params[:type].keys.each.inject(String.new) do |collected, last|
          collected += "#{Incident.kind_for(last.to_sym)},"
          collected
        end

        query += "kind IN (#{kinds_selected.chop})"
      else
        query += "kind IS NULL"
      end

      unless params[:complaint_issued].blank?
        query += " AND " unless query.blank?
        query += " complaint_issued = :complaint_issued"
        values.merge!({:complaint_issued =>  params[:complaint_issued] == "true" }) 
      end

      if end_date=range_date_for(params[:range_date])
        query += " AND " unless query.blank?
        query += " date > :end_date"
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
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
    

end