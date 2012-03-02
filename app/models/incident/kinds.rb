module Incident::Kinds
  
  module ClassMethods
    def kinds
      { 1 => :theft, 2 => :assault, 3 => :accident, 4 => :regulation_infraction }
    end
    
    def humanized_kinds
      self.kinds.keys.each.inject({}) do |collected, key| 
        collected[key] = I18n.t("incidents.kinds.#{self.kinds[key]}")
        collected
      end
    end
    
    def kind_for(kind)
      self.kinds.invert[kind]
    end
    
    def humanized_kind_for(kind)
      I18n.t("incidents.kinds.#{kind}")
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def humanized_kind
    Incident.humanized_kind_for(symbol_kind)
  end
  
  def symbol_kind
    Incident.kinds[kind]
  end
  
  def is_of_kind?(kind)
    symbol_kind==kind
  end
  
  def theft_or_assault?
    symbol_kind.eql?(:theft) || symbol_kind.eql?(:assault)
  end
  
  def accident_or_regulation_infraction?
    symbol_kind.eql?(:regulation_infraction) || symbol_kind.eql?(:accident)
  end
end