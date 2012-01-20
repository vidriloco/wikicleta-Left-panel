module Places
  class CommitsController < ApplicationController
    
    before_filter :authenticate_user!
    
    def new
      @place = Place.new
    end
    
    def edit
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
end