class CreateAccessToken < ActiveRecord::Migration
  def change
    create_table :oauth_access_tokens do |t|
      t.uuid :user_id, null: false
      t.string :token, null: false
      t.string :refresh_token
      t.integer :expires_in
      t.string :scopes
      t.datetime :revoked_at
      t.datetime :created_at, null: false
    end
    add_index :oauth_access_tokens, :user_id
    add_index :oauth_access_tokens, :token
    add_index :oauth_access_tokens, :refresh_token
  end
end
