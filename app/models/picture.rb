require 'carrierwave/orm/activerecord'

class Picture < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  after_create :attempt_become_main_photo
  after_destroy :attempt_delete_main_photo
  
  attr_accessible :name, :image, :remote_image_url, :image_cache, :remove_image
  mount_uploader :image, PictureUploader
  
  def self.new_from(params)
    picture=new(:image => params[:file])
    picture.apply_type_from(params)
    picture
  end
  
  def apply_type_from(params)
    if params.has_key?(:bike_id)
      self.imageable_id = params[:bike_id] 
      self.imageable_type = Bike.to_s
    end
  end
  
  private
  
  def attempt_become_main_photo
    if self.imageable.instance_of? Bike
      bike=self.imageable
      bike.update_attribute(:main_picture, self.id) if bike.main_picture.nil?
    end
  end
  
  def attempt_delete_main_photo
    if self.imageable.instance_of? Bike
      bike= self.imageable
      bike.update_attribute(:main_picture, nil) if bike.main_picture == self.id
    end
  end
end
