class Incident < ActiveRecord::Base
  include Shared::Geography
  
  belongs_to :user
  belongs_to :bike_item
  
  validates_presence_of :coordinates, :kind, :description
  validates :vehicle_identifier, :format => /^[[A-Z0-9]\-]+[A-Z0-9]$/, :allow_blank => true, :if => :accident_or_regulation_infraction?
  validates_presence_of :bike_description, :if => :theft_or_assault?
  def self.kinds
    { 1 => :theft, 2 => :assault, 3 => :accident, 4 => :regulation_infraction }
  end
  
  def self.new_with(params, coordinates, user)
    user= user.nil? ? new(params) : new(params.merge(:user => user)) 
    user.apply_geo(coordinates)
    user
  end
  
  def self.humanized_kinds
    self.kinds.keys.each.inject({}) do |collected, key| 
      collected[key] = I18n.t("incidents.kinds.#{self.kinds[key]}")
      collected
    end
  end
  
  def self.kind_for(kind)
    self.kinds.invert[kind]
  end
  
  def self.humanized_kind_for(kind)
    I18n.t("incidents.kinds.#{kind}")
  end
  
  def theft_or_assault?
    symbol_kind.eql?(:theft) || symbol_kind.eql?(:assault)
  end
  
  def accident_or_regulation_infraction?
    symbol_kind.eql?(:regulation_infraction) || symbol_kind.eql?(:accident)
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
  
end
