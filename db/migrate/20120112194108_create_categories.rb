class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :standard_name 
      t.timestamps
    end
    
    require 'factory_girl_rails'
    Factory(:workshop)
    Factory(:restaurant)
    
    add_index(:categories, :standard_name, :unique => true, :name => "standard_name_index")
  end
end
