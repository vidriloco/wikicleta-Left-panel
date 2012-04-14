class Bike < ActiveRecord::Base
  include Categories
  include Likes
  
  acts_as_commentable
  
  has_attached_file :main_photo, 
                    :styles => { :medium => "250", :big => "800", :small => "300x250" },
                    :storage => :cloud_files,
                    :container => (Rails.env == "production") ? "wikicleta" : "wikicleta_other",
                    :cloudfiles_credentials => "#{Rails.root}/config/rackspace_cloudfiles.yml",
                    :ssl => true
  
  has_many :user_like_bikes, :dependent => :destroy
  #has_many :tweaks
  #has_many :borrows
  #has_many :usage_days
  #mileage
  belongs_to :bike_brand
  belongs_to :user
  
  before_post_process :randomize_file_name
  validates_presence_of :name, :kind, :bike_brand, :user
  
  validates_attachment_presence     :main_photo
  validates_attachment_content_type :main_photo, :content_type => %r{image/.*}
  
  before_validation :validate_attachment_size
  
  scope :most_popular, order('likes_count DESC')
  scope :all_from_user, lambda { |user| where("user_id = ?", user.id) } 
  
  def randomize_file_name
    return if main_photo_file_name.nil?
    extension = File.extname(main_photo_file_name).downcase
    self.main_photo.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")
  end
  
  def brand
    return if bike_brand.nil?
    bike_brand.name
  end
  
  def owner
    return if user.nil?
    user.username
  end
  
  def contact
    return "---" if(user.nil? || user.email.blank?)
    user.email
  end
  
  def self.new_with_owner(params, owner)
    new(params.merge(:user => owner))
  end
  
  def update_attributes_with_owner(params, owner)
    return self.update_attributes(params) if self.user = owner
    false
  end
  
  private
  
  def validate_attachment_size
    return if main_photo_file_size.nil?
    if main_photo_file_size > 2.megabytes
      self.errors.add(:base, I18n.t('bikes.views.form.validations.file_size'))
    end
  end
end
