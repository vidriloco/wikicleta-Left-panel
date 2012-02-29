class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :layout_by_resource
  
  def after_sign_in_path_for(resource)
    if user_signed_in?
      stored_location_for(resource) || root_path
    elsif admin_signed_in?
      stored_location_for(resource) || admins_index_path
    end
  end
  
  

    protected

    def layout_by_resource
      if devise_controller?
        "access"
      else
        "application"
      end
    end
end
  