class StreetMark < ActiveRecord::Base
  has_many :street_mark_rankings
  
  belongs_to :user
  
  validates_presence_of :segment_path, :name
  
  def self.build_new(params)
    line_string_coords = params.delete(:segment_path).map do |item|
      Point.from_lon_lat(item["Va"], item["Ua"], 4326)
    end
    new(params.merge(:segment_path => LineString.from_points(line_string_coords, 4326)))
  end
  
  def as_json(options={})
    {
      :segment_path => segment_path_to_json,
      :name => name,
      :id => id,
      :created_at => created_at.to_time.iso8601,
      :updated_at => updated_at.to_time.iso8601
    }
  end
  
  private
    def segment_path_to_json
      segment_path.points.map do |point|
        {"Ua" => point.lat, "Va" => point.lon}
      end
    end
end
