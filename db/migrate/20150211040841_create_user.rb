class CreateUser < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
    create_table :users, { id: :uuid } do |t|
      t.string :name
      t.timestamps null: true
    end
  end
end
