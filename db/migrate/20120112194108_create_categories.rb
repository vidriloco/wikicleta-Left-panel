class CreateCategories < ActiveRecord::Migration
  
  def self.up
    
    create_table :categories do |t|
      t.string :standard_name 
      t.timestamps
    end
    
    add_index(:categories, :standard_name, :unique => true, :name => "standard_name_index")
    
    require 'factory_girl_rails'
    Factory(:workshop)
    Factory(:restaurant)
  end
  
  def self.down
    drop_table :categories
  end
end
