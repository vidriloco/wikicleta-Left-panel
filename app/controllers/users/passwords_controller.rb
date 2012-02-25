class Users::PasswordsController < Devise::PasswordsController
  
  skip_before_filter :require_no_authentication
  before_filter :mailer_set_url_options

  def after_sending_reset_password_instructions_path_for(resource_name)
    if user_signed_in?
      settings_access_path
    else
      super
    end
  end
  
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end