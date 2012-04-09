module Incident::Categories
  
  module ClassMethods
    def kind_for(number)
      Bike.category_for(:incidents, number)
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
    
  def is_of_kind?(kind)
    symbol_kind==kind
  end
  
  def symbol_kind
    Bike.category_symbol_for(:incidents, kind)
  end
  
  def theft_or_assault?
    theft? || symbol_kind.eql?(:assault)
  end
  
  def theft?
    symbol_kind.eql?(:theft)
  end
  
  def accident_or_regulation_infraction?
    symbol_kind.eql?(:regulation_infraction) || symbol_kind.eql?(:accident)
  end
  
  def accident_or_theft_or_assault?
    theft_or_assault? || symbol_kind.eql?(:assault)
  end
end