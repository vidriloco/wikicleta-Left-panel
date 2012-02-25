module Place::Geography
  
  module ClassMethods
    def make_polygon(coordinates)
      return nil if coordinates.nil?
      return nil if coordinates[:sw].blank? || coordinates[:ne].blank?

      lat_so, lon_so = coordinates[:sw].split(',').map { |n| n.to_f }
      lat_no, lon_no = coordinates[:ne].split(',').map { |n| n.to_f }

      # Empezando en (0,0) en sentido de las manecillas del reloj
      Polygon.from_coordinates([[[lon_so, lat_no], [lon_no, lat_no], [lon_no, lat_so], [lon_so, lat_so], [lon_so, lat_no]]],4326)
    end
  end
  
  def apply_geo(coordinates)
    return self if coordinates.nil? || (coordinates["lon"].blank? || coordinates["lat"].blank?)
    self.coordinates = Point.from_lon_lat(coordinates["lon"].to_f, coordinates["lat"].to_f, 4326)
    self
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  private 
  def coordinates_are_set
    errors.add(:base, I18n.t('places.custom_validations.coordinates_missing')) if self.coordinates.nil?
  end
end