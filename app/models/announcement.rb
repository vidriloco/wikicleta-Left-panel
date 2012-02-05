class Announcement < ActiveRecord::Base
  belongs_to :place
  belongs_to :announcer, :class_name => "User"
  
  validates_presence_of :header, :message, :start_date, :end_date, :announcer, :place
  validate :hour_is_correct
  
  def hour_is_correct
    if start_date > end_date
      errors.add(:base, I18n.t('places.subviews.show.announcements.validations.errors.time_mismatch'))
    end
  end 
end
