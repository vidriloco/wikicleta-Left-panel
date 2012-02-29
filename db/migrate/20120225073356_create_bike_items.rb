class CreateBikeItems < ActiveRecord::Migration
  
  def self.up
    create_table :bike_items do |t|
      t.integer :category
      t.string :name
      t.string :details
      t.timestamps
    end
    
    BikeItem.create_security_item(:name => "Cable")
    BikeItem.create_security_item(:name => "Cadena")
    BikeItem.create_security_item(:name => "U-lock")
    BikeItem.create_security_item(:name => "Tipo Esposas")
  end
  
  def self.down
    drop_table :bike_items
  end
end
