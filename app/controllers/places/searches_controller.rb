module Places
  class SearchesController < ApplicationController
    def main
      @categories = Category.all
    end
    
    def execute_main
      @places = Place.find_by(params[:search])
      
      render :template => 'places/searches/main_results'
    end
  end
end