class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.references :user
      t.string :name
      t.integer :level
      t.boolean :read
      t.boolean :commit
      t.boolean :export
      t.boolean :check
      t.boolean :modify
      t.boolean :admin

      t.timestamps
    end
    add_index :roles, :user_id
  end
end
