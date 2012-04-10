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
  
  def theft?
    is_of_kind?(:theft)
  end
  
  def assault?
    is_of_kind?(:assault)
  end
  
  def accident?
    is_of_kind?(:accident)
  end
  
  def regulation_infraction?
    is_of_kind?(:regulation_infraction)
  end
  
  def theft_or_assault?
    theft? || assault?
  end
  
  def accident_or_regulation_infraction?
    regulation_infraction? || accident?
  end
  
  def accident_or_theft_or_assault?
    theft_or_assault? || accident?
  end
end