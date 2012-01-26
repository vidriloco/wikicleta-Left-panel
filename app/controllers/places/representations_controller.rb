module Places
  class RepresentationsController < ApplicationController
        
    def show
      @place = Place.find(params[:id])
    end
    
    def comments
      @place = Place.with_comments(params[:id])
      
      respond_to do |format|
        format.js
      end
    end
    
  end
end