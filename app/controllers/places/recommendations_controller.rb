class Places::RecommendationsController < ApplicationController
    
  def index
    @place = Place.include_with(params[:place_id], :recommendations)
    
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @place = Place.find(params[:place_id])
    
    if user_signed_in?
      @recommendation_status_changed = !@place.change_recommendation_status_for(current_user, params[:recommend])
    end
    
    respond_to do |format|
      format.js 
    end
  end
  
end
