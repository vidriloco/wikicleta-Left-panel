module Place::Announcements
  
  def add_announcement(user, params)
    return false if !self.verified_owner_is?(user) 
    announcement = Announcement.create({:announcer => user, :place => self}.merge(process_dates(params)))
    self.announcements << announcement
    announcement
  end
  
  private
  def process_dates(params)
    new_params = {}
    [:start_date, :end_date].each do |date|
      if params.has_key?(date) && params[date].is_a?(Hash)
        sd = params[date]
        new_params[date] = Time.local(sd["year"], sd["month"], sd["day"], sd["hour"], sd["minute"])
        params.delete(date)
      end
    end
    new_params.merge(params)
  end
end
