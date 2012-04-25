class ProfilesController < ApplicationController
  layout 'profiles'
  
  before_filter :find, :only => [:index, :friends]
  
  def index
    render(:template => 'profiles/not_found') && return if @user.nil?
  end
  
  def friends
    render(:template => 'profiles/not_found') && return if @user.nil?
  end
  
  private 
  
  def find
    @user = User.find_by_username(params[:username])
  end
end