module Place::Geography
  def apply_geo(coordinates)
    return self if coordinates.nil? || (coordinates["lon"].blank? || coordinates["lat"].blank?)
    self.coordinates = Point.from_lon_lat(coordinates["lon"].to_f, coordinates["lat"].to_f, 4326)
    self
  end
  
  private 
  def coordinates_are_set
    errors.add(:base, I18n.t('places.custom_validations.coordinates_missing')) if self.coordinates.nil?
  end
  
  def twitter_correct_format
    return true if self.twitter.blank?
    errors.add(:twitter, I18n.t('places.custom_validations.twitter_bad_format')) if !self.twitter.match(/@(\w+)/).nil?
  end
end