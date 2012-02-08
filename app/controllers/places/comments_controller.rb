module Places
  class CommentsController < ApplicationController
    
    before_filter :authenticate_user!, :except => [:index]
    
    def index
      @place = Place.include_with(params[:place_id], :commenters)
      
      respond_to do |format|
        format.js
      end
    end
    
    def create
      @place = Place.find(params[:place_id])
      @place.add_comment(current_user, params[:place_comment][:content]) if user_signed_in?
      
      respond_to do |format|
        format.js 
      end
    end
    
    def destroy
      @place_comment = PlaceComment.find(params[:id])
      
      if @place_comment.owned_by?(current_user)
        @place = @place_comment.place
        @place_comment_destroyed = @place_comment.destroy
      
        respond_to do |format|
          format.js 
        end
      else
        render(:nothing => true)
      end
    end
    
  end
end