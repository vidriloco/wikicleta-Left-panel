require 'carrierwave/orm/activerecord'

class Picture < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  after_create :set_as_main_picture
  after_destroy :unset_as_main_picture
  
  attr_accessible :image, :remote_image_url, :image_cache, :remove_image
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
  
  def become_main_picture
    imageable.update_attribute(:main_picture, self.id)
  end
  
  def main_picture?
    imageable.main_picture == self.id
  end
  
  private
  
  def set_as_main_picture
    become_main_picture if imageable.main_picture.nil?
  end
  
  def unset_as_main_picture
    imageable.update_attribute(:main_picture, nil) if main_picture?
  end
end
