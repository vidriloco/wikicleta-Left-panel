class BikeItem < ActiveRecord::Base
  has_many :incidents
  
  def self.categories
    {:security => 1, :safety => 2}
  end
end
