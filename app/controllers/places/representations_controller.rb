module Places
  class RepresentationsController < ApplicationController
        
    def show
      @place = Place.find(params[:id])
    end
    
    def announcements
      @place = Place.include_with(params[:id], :announcements)
      
      respond_to do |format|
        format.js
      end
    end
    
  end
end