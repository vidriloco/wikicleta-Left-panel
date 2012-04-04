class Bikes::LikesController < ApplicationController
    
  before_filter :authenticate_user!
    
  def create
    @bike = Bike.find(params[:id])
    @bike.register_like_from(current_user)
    respond_with_changed_template
  end
  
  def destroy
    @bike = Bike.find(params[:id])
    @bike.destroy_like_from(current_user)
    respond_with_changed_template
  end
  
  private
  def respond_with_changed_template
    respond_to do |format|
      format.js { render :template => 'bikes/likes/change_count' }
    end
  end
end