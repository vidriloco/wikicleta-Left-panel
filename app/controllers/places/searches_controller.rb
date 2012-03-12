module Places
  class SearchesController < ApplicationController
    layout 'map'
    
    def main
      @categories = Category.all
    end
    
    def execute_main
      @places = Place.find_by(params[:search])
      
      @search_mode = true
      render :template => 'places/index', :layout => 'places' 
    end
  end
end