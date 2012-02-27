module Place::Geography
  private 
  def coordinates_are_set
    errors.add(:base, I18n.t('places.custom_validations.coordinates_missing')) if self.coordinates.nil?
  end
end