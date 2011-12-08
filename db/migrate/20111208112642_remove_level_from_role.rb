class RemoveLevelFromRole < ActiveRecord::Migration
  def up
    remove_column :roles, :level
  end

  def down
    add_column :roles, :level, :integer
  end
end
