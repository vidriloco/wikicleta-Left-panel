class BikeStatus < ActiveRecord::Base
  belongs_to :bike
  validates_presence_of :bike_id, :concept
  
  def self.find_all_for_bike(bike_id)
    categories = Bike.category_list_for(:statuses).invert
    find(:all, :conditions => {bike_id: bike_id }).each do |bike_status|
      categories[Bike.category_symbol_for(:statuses, bike_status.concept)] = bike_status
    end
    categories.each_key do |key|
      categories[key] = BikeStatus.new if(categories[key].is_a? Integer)
    end
  end
  
  def self.create_with_bike(bike_id, params)
    BikeStatus.create(params.merge(:bike_id => bike_id))
  end
  
  def self.update_with(id, params) 
    bike_status = self.find(id)   
    
    if bike_status
      params.delete(:concept) && bike_status.update_attributes(params)
    end
    bike_status
  end
  
  def humanized_status
    Bike.humanized_category_for(:statuses, concept)
  end
  
  def status
    Bike.category_symbol_for(:statuses, concept)
  end
  
  def is_available?
    availability == true
  end
end
