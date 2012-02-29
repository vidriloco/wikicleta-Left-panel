class IncidentsController < ActionController::Base
  layout 'full_page_map'
  
  def new
    @incident = Incident.new
  end
  
  def create
    @incident = Incident.new_with(params[:incident], params[:coordinates], current_user)
    
    if @incident.save
      redirect_to incidents_path, :notice => I18n.t('incidents.create.saved')
    else
      render :new
    end
  end
  
  def index
    @incident_ocurrence = Incident.count(:all, :group => :kind)
    @incidents = Incident.all
  end
end