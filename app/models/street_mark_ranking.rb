require 'redis/counter'

class StreetMarkRanking < ActiveRecord::Base
  
  belongs_to :street_mark
  belongs_to :user
  
  validates_presence_of :user
  validates_presence_of :street_mark
  
  after_create :update_counters
  
  def self.aspects
    # flujo vehicular, comodidad, baches y altura
   (1..4).to_a
  end
  
  def self.aspects_options
    { 1 => (1..2).to_a, 
      2 => (1..2).to_a, 
      3 => (1..3).to_a, 
      4 => (1..2).to_a }
  end
  
  def self.aspect_field_for(number)
    "aspect_#{number}"
  end
  
  def self.statistics_for(street_mark_id)
    StreetMarkRanking.generate_counters.each.inject({}) do |collected, last|
      counter_id = "#{StreetMarkRanking}-#{street_mark_id}-#{last[:aspect]}-#{last[:option]}"
      collected.merge!("#{last[:aspect]}-#{last[:option]}" => Redis::Counter.new(counter_id).value)
      collected
    end
  end
  
  private
    def update_counters
      StreetMarkRanking.generate_counters.each do |counter_h|
        counter = Redis::Counter.new("#{StreetMarkRanking}-#{street_mark_id}-#{counter_h[:aspect]}-#{counter_h[:option]}")
        counter.increment if(self.send("aspect_#{counter_h[:aspect]}") == counter_h[:option])
      end      
    end
    
    def self.generate_counters
      counters = Array.new
      StreetMarkRanking.aspects.each do |aspect|
        StreetMarkRanking.aspects_options[aspect].each do |option|
          counters << {:aspect => aspect, :option => option}
        end
      end
      counters
    end
  
end
