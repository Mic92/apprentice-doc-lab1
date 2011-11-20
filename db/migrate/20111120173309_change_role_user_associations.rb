class ChangeRoleUserAssociations < ActiveRecord::Migration
 def up
    add_column :users, :role_id, :integer
    remove_column :roles, :user_id
    add_index :users, :role_id
  end

  def down
    remove_column :users, :role_id
    add_column :roles, :user_id, :integer
    add_index :roles, :user_id
  end
end
