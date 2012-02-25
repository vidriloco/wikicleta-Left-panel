class Authorization < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :uid, :provider, :token
  
  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end
  
  def capital_provider
    provider.capitalize
  end
    
end
