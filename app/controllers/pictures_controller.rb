class PicturesController < ApplicationController
  
  def index

  end

  def create
    @picture = Picture.new_from(params)
    
    if @picture.save
      render json: {:success => true, :src => @picture.image.url(:thumb)}
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    render :json => true
  end
    
end
