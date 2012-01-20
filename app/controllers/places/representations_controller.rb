module Places
  class RepresentationsController < ApplicationController
    def show
      @place = Place.find(params[:id])
    end
  end
end