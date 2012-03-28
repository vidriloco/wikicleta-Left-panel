class Map::StreetMarkRankingsController < Map::BaseController  
    
  def create
    @street_mark_ranking = StreetMarkRanking.new(params[:street_mark_ranking].merge(:user_id => current_user.id))
    @street_mark_ranking.save
    
    render :json => @street_mark_ranking.to_json
  end
  
end