class Places::EvaluationsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def new
    @place = Place.find(params[:place_id])
    
    respond_to do |format|
      format.js
    end
  end
  
  def create
    @place = Place.find(params[:place_id])
    @survey = Survey.from_hash(params[:survey].merge(:user => current_user, 
                                                     :evaluable => @place))
    @survey.save
    
    respond_to do |format|
      format.js
    end
  end
end
