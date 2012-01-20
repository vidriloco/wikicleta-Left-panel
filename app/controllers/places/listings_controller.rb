module Places
  class ListingsController < ApplicationController
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
  end
end