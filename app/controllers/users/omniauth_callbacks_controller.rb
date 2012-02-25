class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  before_filter :check_for_failure, :except => [:create, :failure, :cancel]
  
  def twitter
    if previous_auth=peek_authorization
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", :kind => "Twitter")
      sign_in_and_redirect previous_auth.user, :event => :authentication
    else
      @user = User.new_from_oauth_params(auth_hash)
    end
  end
  
  def facebook
    if previous_auth=peek_authorization
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", :kind => "Facebook")
      sign_in_and_redirect previous_auth.user, :event => :authentication
    else
      @user = User.new_from_oauth_params(auth_hash)
    end
  end
  
  def create
    @user = User.new(params[:user])
    authorization=@user.add_authorization(session["devise.oauth_data"])
    
    if @user.save
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", :kind => authorization.capital_provider)
      sign_in_and_redirect @user, :event => :authentication
    else
      provider_action = session["devise.oauth_data"][:provider]
      render :action => provider_action
    end
  end
  
  def cancel
    session["devise.oauth_data"]=nil
    redirect_to new_user_session_path
  end
  
  def failure
  end
  
  protected
  
  def check_for_failure
    render :action => :failure if auth_hash.nil?
  end
  
  def peek_authorization
    auth_to_session
    Authorization.find_from_hash(auth_hash)
  end
  
  def auth_hash
    request.env["omniauth.auth"]
  end
  
  def auth_to_session
    cred =  auth_hash["credentials"]
    session["devise.oauth_data"] = {:provider => auth_hash["provider"], :uid => auth_hash["uid"], :token => cred["token"], :secret => cred["secret"]}
  end
end
