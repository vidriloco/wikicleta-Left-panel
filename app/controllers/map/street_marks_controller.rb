class Map::StreetMarksController < Map::BaseController  
  
  respond_to :json
  
  def index
    @street_marks = StreetMark.all
  end
  
  def create
    @street_mark = StreetMark.build_new(post_params.merge(:user_id => current_user))
    @street_mark.save
    respond_with @street_mark, :location => map_street_mark_url(@street_mark)
  end
  
  private
  def post_params
    params[:street_mark].slice(:name, :segment_path)
  end
end