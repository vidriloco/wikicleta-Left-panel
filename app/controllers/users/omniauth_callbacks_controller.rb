class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  layout 'application'
  before_filter :check_for_failure, :except => [:create, :failure, :cancel, :destroy]
  before_filter :authenticate_user!
  
  def twitter
    auth_to_session
    
    return true if add_authorization_strategy?
    return true if already_authorized_with?('Twitter')
    @user = User.new_from_oauth_params(auth_hash)
  end
  
  def facebook
    auth_to_session
    
    return true if add_authorization_strategy?
    return true if already_authorized_with?('Facebook')
    @user = User.new_from_oauth_params(auth_hash)
  end
  
  def create
    @user = User.new(params[:user].merge!(:externally_registered => true))
    auth=@user.add_authorization(session["devise.oauth_data"])
    
    if @user.save
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", :kind => auth.provider_name)
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
  
  def destroy
    @authorization = Authorization.find(params[:id])
    @authorization.destroy
  
    redirect_to settings_access_path, with_message('delete', 'success', @authorization.provider_name)
  end
  
  protected
  
  def with_message(action, status, social_net="")
    msj=I18n.t("user_accounts.settings.authorizations.#{action}.#{status}", :social_network => social_net)
    return { :notice => msj } if status=='success'
    { :alert => msj }
  end
  
  # adds to the current user a new authorization strategy (it will not sign the user in as him should be already in)
  def add_authorization_strategy?
    if user_signed_in?
      auth = current_user.add_authorization(session["devise.oauth_data"], true)
      status = auth.persisted? ? 'success' : 'failure'
      redirect_to(settings_access_path, with_message('add', status, auth.provider_name))
      return true
    end
    false
  end
  
  # checks the cookies and attempts to log-in with them
  def already_authorized_with?(auth_scheme)
    auth=Authorization.find_from_hash(auth_hash)
    if auth
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", :kind => auth_scheme)
      sign_in_and_redirect auth.user, :event => :authentication
      return true
    end
    false
  end
  
  def check_for_failure
    render(:action => :failure) if auth_hash.nil?
  end
  
  def auth_hash
    request.env["omniauth.auth"]
  end
  
  def auth_to_session
    cred =  auth_hash["credentials"]
    session["devise.oauth_data"] = {:provider => auth_hash["provider"], :uid => auth_hash["uid"], :token => cred["token"], :secret => cred["secret"]}
  end
end
