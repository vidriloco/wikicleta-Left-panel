module ApplicationHelper
  
  def provider_is?(provider)
    session["devise.oauth_data"][:provider].eql?(provider.to_s)
  end
  
  def errors_for(field, object)
    return "field-with-errors" unless object.errors[field].empty? 
  end
end
