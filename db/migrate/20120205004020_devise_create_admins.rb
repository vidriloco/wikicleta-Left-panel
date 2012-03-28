class DeviseCreateAdmins < ActiveRecord::Migration
  def change
    create_table(:admins) do |t|
      t.database_authenticatable :null => false
      t.timestamps
    end

    add_index :admins, :email, :unique => true, :name => "admins_idx"
    
    Admin.create(:email => "admin@wikiando.com", :password => "wikiandar", :password_confirmation => "wikiandar")
  end
  
end
