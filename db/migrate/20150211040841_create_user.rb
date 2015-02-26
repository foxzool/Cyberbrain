class CreateUser < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
    create_table :users, id: :uuid , default: 'uuid_generate_v4()' do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.timestamps null: false
    end
  end
end
