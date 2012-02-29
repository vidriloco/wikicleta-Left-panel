class BikeItem < ActiveRecord::Base
  has_many :incidents
  
  def self.categories
    {:security => 1, :safety => 2}
  end
  
  def self.create_security_item(params)
    new(params.merge(:category => categories[:security])).save
  end
end
