class BikeBrand < ActiveRecord::Base
  has_many :bikes
  
  scope :ordered, order('name ASC')
end
