class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
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
  end
end
