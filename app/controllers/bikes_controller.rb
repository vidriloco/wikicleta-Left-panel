class BikesController < ApplicationController
  layout 'application'
  before_filter :map_enabled 
  
  def index
  end
  
  def new
  end
  
  def search
  end
  
  def popular
  end
  
  private
  def map_enabled
    @map_enabled = false
  end
  
end