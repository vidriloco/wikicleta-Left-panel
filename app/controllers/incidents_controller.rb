class IncidentsController < ActionController::Base
  layout 'full_page_map'
  
  def new
    @incident = Incident.new
  end
  
  def create
    @incident = Incident.new_with(params[:incident], params[:coordinates], current_user)
    
    if @incident.save
      flash[:posted_incident] = @incident
      redirect_to incidents_path, :notice => I18n.t('incidents.create.saved')
    else
      render :new
    end
  end
  
  def index
    @incidents = Incident.filtering_with(:nothing)
  end
  
  def destroy
    incident = Incident.find(params[:id])
    incident.destroy
    
    @incidents = Incident.filtering_with(:nothing)
    
    respond_to do |format|
      format.js
    end
  end
  
  def filtering
    @incidents = Incident.filtering_with(params[:incident])
    
    respond_to do |format|
      format.js
    end
  end
end