class Incident < ActiveRecord::Base
  include Shared::Geography
  include Categories
  include Filtering
  
  belongs_to :user
  belongs_to :bike
  
  validates_presence_of :coordinates, :kind, :description
  validates_presence_of :lock_used, :if => :theft?
  validates_presence_of :bike, :if => :accident_or_theft_or_assault?
  validates_presence_of :user, :if => :accident_or_theft_or_assault?
  validates :vehicle_identifier, :format => /^[^-]([A-Z0-9\-]){3,}[^-]$/, :allow_blank => true, :if => :accident_or_regulation_infraction?
  
  attr_protected :user_id
  
  def self.new_with(params, coordinates, user)
    user= user.nil? ? new(params) : new(params.merge(:user => user)) 
    user.apply_geo(coordinates)
    user
  end
  
  def self.categorized_by_kinds(incidents=nil)
    (incidents || all).each.inject({:total => 0}) do |collected, incident| 
      collected[:total] += 1
      collected[incident.kind] ||= []
      collected[incident.kind] << incident
      collected
    end
  end
  
  def owned_by_user?(passed_user)
    return false if passed_user.nil?
    user = passed_user
  end
  
  def is_bike_related?
    return !bike.nil?
  end
  
end
