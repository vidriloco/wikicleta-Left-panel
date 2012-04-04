module Bike::Categories
  
  module ClassMethods
    def category_list_for(selector)
      self.send(selector)
    end
    
    def humanized_categories_for(selector)
      items = self.send(selector)
      items.keys.each.inject({}) do |collected, key| 
        collected[key] = I18n.t("bikes.categories.#{selector.to_s}.#{items[key]}")
        collected
      end
    end
    
    def category_for(selector, name)
      self.send(selector).invert[name]
    end
    
    def humanized_category_for(selector, identifier)
      I18n.t("bikes.categories.types.#{self.send(selector)[identifier]}")
    end
    
    private
    def types
      { 1 => :urban, 2 => :mountain, 3 => :route, 4 => :fixie}
    end
    
    def incidents
      { 1 => :theft, 2 => :assault, 3 => :accident, 4 => :regulation_infraction }
    end
    
    def security
      {}
    end
    
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
end