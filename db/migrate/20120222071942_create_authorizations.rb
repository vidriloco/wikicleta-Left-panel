class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.integer :user_id
      t.string :secret
      t.string :token
      t.timestamps
    end
    
    add_index(:authorizations, [:provider, :uid], :unique => true, :name => "authorizations_provider_uid_idx")
    add_index(:authorizations, [:provider, :user_id], :unique => true, :name => "authorizations_provider_user_id_idx")
  end
end
