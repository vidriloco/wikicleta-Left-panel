module Places
  class AnnouncementsController < ApplicationController
  
    before_filter :authenticate_user!, :except => [:index]
  
    def index
      @place = Place.include_with(params[:place_id], :announcements)
      
      respond_to do |format|
        format.js
      end
    end
  
    def create
    
      @place = Place.find(params[:place_id])

      if (@announcement = @place.add_announcement(current_user, params[:announcement]))
        respond_to do |format|
          format.js 
        end
      else
        render(:nothing => true)
      end
    end
  
    def destroy
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
    
  end
end