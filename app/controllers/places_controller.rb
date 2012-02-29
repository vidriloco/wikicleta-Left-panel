class PlacesController < ApplicationController
  layout 'application'
  
  before_filter :authenticate_user!, :except => [:index, :show]

  def new
    @place = Place.new
  end
  
  def edit
    @place = Place.find(params[:id])
  end
  
  def index
    if params.has_key?(:filtered)
      @places = Place.filtering_with(params[:ordered_by], params[:categories])
    else
      @categories = Category.all
      @places = Place.order("mobility_kindness_index DESC, created_at ASC")
    end
    
    respond_to do |format|
      format.html #index.html.erb
      format.js
    end
  end
  
  def show
    @place = Place.find(params[:id])
  end
  
  def create
    @place = Place.new_with_owner(params[:place], current_user)
    @place.apply_geo(params[:coordinates])
    
    respond_to do |format|
      if @place.save
        format.html { redirect_to(@place) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @place = Place.find(params[:id])
    @place.apply_geo(params[:coordinates])
    
    respond_to do |format|
      if @place.update_attributes(params[:place])
        format.html { redirect_to(@place) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end