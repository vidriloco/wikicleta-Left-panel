class Authorization < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :uid, :provider, :token
  
  before_save :is_uid_and_provider_unique?, :is_user_and_provider_unique?
  
  def self.supported
    [:twitter, :facebook]
  end
  
  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end
  
  def provider_name
    provider.capitalize
  end
  
  private
  
  def is_uid_and_provider_unique?
    Authorization.find(:first, :conditions => {:provider => provider, :uid => uid } ).nil?
  end
  
  def is_user_and_provider_unique?
    Authorization.find(:first, :conditions => {:provider => provider, :user_id => user_id } ).nil?
  end
    
end
