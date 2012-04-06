class Map::IncidentsController < Map::BaseController
  
  def create
    @incident = Incident.new_with(params[:incident], params[:coordinates], current_user)
    @incident.save

    respond_to do |format|
      format.js 
    end
  end
  
  def index
    respond_to do |format|
      format.js { @incidents = Incident.categorized_by_kinds }
      format.html { @incident = Incident.new }
    end
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