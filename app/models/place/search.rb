module Place::Search
  module ClassMethods
    
    def find_by(params)
      params=params[:place]
      
      str_keys = String.new
      arr_vals = Array.new
      
      unless params[:name].blank?
        str_keys += "name ILIKE ?"
        arr_vals << "%#{params[:name]}%"
      end
      
      unless params[:description].blank?
        str_keys += " AND " unless str_keys.blank?
        str_keys += "description ILIKE ?"
        arr_vals << "%#{params[:description]}%"
      end
      
      unless params[:categories].blank?
        category_list = params[:categories].keys.each.inject("") do |result, word| 
          result += "#{word},"
          result 
        end
        
        str_keys += " AND " unless str_keys.blank?
        str_keys += "category_id IN (#{category_list.chop})"
      end
      
      if params[:map_enabled]
        polygon_given = self.make_polygon(params[:coordinates])
        if polygon_given
          str_keys += " AND " unless str_keys.blank?
          str_keys += "ST_Within(places.coordinates, ST_GeomFromEWKT(E'#{polygon_given.as_hex_ewkb}'))"
        end
      end
      
      self.find(:all, :conditions => [str_keys]+arr_vals)
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
end
