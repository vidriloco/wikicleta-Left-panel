class Places::EvaluationsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :find_place, :except => [:edit]
  
  def new
    respond_to do |format|
      format.js
    end
  end
  
  def show
  end
  
  def create
    @survey = Survey.from_hash(params[:survey].merge(:user => current_user, 
                                                     :evaluable => @place))
    @survey.save
    
    respond_to do |format|
      format.js { render 'show_listing' }
    end
  end
  
  def edit
    @survey = Survey.find(params[:id]) 
    @place = @survey.evaluable
    
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @survey = Survey.from_hash(params[:survey].merge(:user => current_user, 
                                                     :evaluable => @place))
    if @survey.save
      Survey.find(params[:id]).destroy
    end
    
    respond_to do |format|
      format.js { render 'show_listing' }
    end
    
  end
  
  private 
  def find_place
    @place = Place.find(params[:place_id])
  end
end
