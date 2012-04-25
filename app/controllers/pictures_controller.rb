class PicturesController < ApplicationController
  
  before_filter :find_picture, :only => [:destroy, :set_main, :change_caption]

  def create
    @picture = Picture.new_from(params)
    
    if @picture.save
      render :json => {:success => true}
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @picture.destroy
    
    respond_to do |format|
      format.js { render :action => 'update' }
    end
  end
  
  # TODO: Merge into update method
  def set_main
    @picture.become_main_picture
    
    respond_to do |format|
      format.js
    end
  end
  
  # TODO: Merge into update method
  def change_caption
    @picture.update_attribute(:caption, params[:value])
    
    respond_to do |format|
      format.js { render :action => 'update' }
    end
  end
  
  def update
    respond_to do |format|
      format.js
    end
  end
  
  private
  def find_picture
    @picture = Picture.find(params[:id])
  end
    
end
