module Places
  class CommitsController < ApplicationController
    
    before_filter :authenticate_user!, :except => [:follow, :comment]
    before_filter :find_user, :only => [:edit, :update, :follow, :comment]
    
    def new
      @place = Place.new
    end
    
    def edit
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
      @place.apply_geo(params[:coordinates])
      
      respond_to do |format|
        if @place.update_attributes(params[:place])
          format.html { redirect_to(@place) }
        else
          format.html { render :action => "edit" }
        end
      end
    end
    
    def follow
      if user_signed_in?
        @unfollowed_by_owner = !@place.change_follow_status_for(current_user, params[:follow])
      end
      
      respond_to do |format|
        format.js 
      end
    end
    
    def comment
      @place.add_comment(current_user, params[:place_comment][:content]) if user_signed_in?
      
      respond_to do |format|
        format.js 
      end
    end
    
    def uncomment
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
    
    def announce
      
      @place = Place.find(params[:place_id])

      if (@announcement = @place.add_announcement(current_user, params[:announcement]))
        respond_to do |format|
          format.js 
        end
      else
        render(:nothing => true)
      end
    end
    
    def unannounce
      @announcement = Announcement.find(params[:id])
      @place = @announcement.place
      
      if @place.verified_owner_is?(current_user)
        @announcement_destroyed = @announcement.destroy
      
        respond_to do |format|
          format.js 
        end
      else
        render(:nothing => true)
      end
    end
    
    private
    def find_user
      @place = Place.find(params[:id])
    end
    
  end
end