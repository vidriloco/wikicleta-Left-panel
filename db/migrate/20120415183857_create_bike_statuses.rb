class CreateBikeStatuses < ActiveRecord::Migration
  def change
    create_table :bike_statuses do |t|
      t.integer     :concept, :default => 0
      t.boolean     :availability, :default => false
      t.integer     :bike_id
      
      # for share concept
      t.boolean     :only_friends, :default => true
      
      # for rent concept
      t.float       :hour_cost
      t.float       :day_cost
      t.float       :month_cost
      
      # for sell concept
      t.float       :price
      t.timestamps
    end
    
    add_index(:bike_statuses, [:bike_id, :concept], :unique => true, :name => "bike_statuses_idx")
  end
end
