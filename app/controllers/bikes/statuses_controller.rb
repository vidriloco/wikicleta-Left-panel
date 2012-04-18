class Bikes::StatusesController < ApplicationController
    
  before_filter :authenticate_user!
  
  def create
    @bike_status = BikeStatus.create_with_bike(params[:bike_id], params[:bike_status])
    
    respond_to do |format|
      format.js { render :action => 'update' }
    end
  end
  
  def update
    @bike_status = BikeStatus.update_with(params[:id], params[:bike_status])
    
    respond_to do |format|
      format.js
    end
  end
  
end