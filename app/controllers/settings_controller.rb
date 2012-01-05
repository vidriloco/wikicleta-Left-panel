class SettingsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :expose_user
  
  def account
  end
  
  def access
  end
  
  def profile
  end
  
  def changed    
    params_hash = params[:user]
    params_hash.merge!(:current_password => params[:current_password]) if params.has_key?(:current_password)
    
    if @user.check_parameters_and_password(params_hash) && @user.update_attributes(params_hash)
      sign_in(@user, :bypass => true)
      flash[:notice] = I18n.t("user_accounts.settings.successful_save")
    else
      flash[:notice] = I18n.t("user_accounts.settings.unsuccessful_save")
    end
    
    redirect_to request.referer || 'account'    
  end
  
  private 
  
  def expose_user
    @user = current_user
  end
end
