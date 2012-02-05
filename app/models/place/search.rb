module Place::Search
  module ClassMethods
    
    def find_by(params)
      params=params[:place]
      
      str_keys = String.new
      str_vals = String.new
      
      unless params[:name].blank?
        str_keys += "name ILIKE ?"
        str_vals += "%#{params[:name]}%"
      end
      
      unless params[:description].blank?
        str_keys += " AND " unless str_keys.blank?
        str_keys += "description ILIKE ?"
        str_vals += "%#{params[:description]}%"
      end
      
      self.find(:all, :conditions => [ str_keys, str_vals ])
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
end
