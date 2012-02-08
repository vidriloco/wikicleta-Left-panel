class Admins::MainController < ApplicationController
  layout 'admin'
  
  before_filter :authenticate_admin!
  
  def index
    @admin = current_admin
  end
end