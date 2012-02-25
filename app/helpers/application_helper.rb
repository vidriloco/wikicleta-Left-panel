module ApplicationHelper
  
  def provider_is?(provider)
    session["devise.oauth_data"][:provider].eql?(provider.to_s)
  end
end
