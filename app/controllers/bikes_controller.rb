class BikesController < ApplicationController
  layout 'application'
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :mine] 
  before_filter :find_bike, :only => [:edit, :update, :show, :destroy]
  
  def index
    @bikes = Bike.order('created_at DESC')
  end
  
  def search
  end
  
  def popular
    @bikes = Bike.most_popular
    render :action => 'index'
  end
  
  def mine
    @bikes = Bike.all_from_user(current_user)
    render :action => 'index'
  end
  
  def new
    @bike = Bike.new
  end
  
  def create
    @bike = Bike.new_with_owner(params[:bike], current_user)
    if @bike.save
      redirect_to @bike, :notice => I18n.t('bikes.messages.saved')
    else
      render :action => 'new'
    end
  end
  
  def edit 
  end
  
  def update
    if @bike.update_attributes_with_owner(params[:bike], current_user)
      redirect_to @bike, :notice => I18n.t('bikes.messages.updated')
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @bike.destroy
    redirect_to bikes_path, :notice => I18n.t('bikes.messages.deleted')
  end

  def show
    @statuses = BikeStatus.find_all_for_bike(params[:id])
  end

  private
  def find_bike
    @bike = Bike.find(params[:id])
  end
  
end