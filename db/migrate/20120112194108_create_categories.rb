class CreateCategories < ActiveRecord::Migration
  
  def self.up
    
    create_table :categories do |t|
      t.string :standard_name 
      t.timestamps
    end
    
    add_index(:categories, :standard_name, :unique => true, :name => "standard_name_idx")
  end
  
  def self.down
    drop_table :categories
  end
end
