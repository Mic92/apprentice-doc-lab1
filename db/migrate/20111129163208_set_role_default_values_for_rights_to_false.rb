class SetRoleDefaultValuesForRightsToFalse < ActiveRecord::Migration
  def up
    change_column :roles, :read, :boolean, :default => false
    change_column :roles, :commit, :boolean, :default => false
    change_column :roles, :export, :boolean, :default => false
    change_column :roles, :check, :boolean, :default => false
    change_column :roles, :modify, :boolean, :default => false
    change_column :roles, :admin, :boolean, :default => false
  end

  def down
    change_column :roles, :read, :boolean
    change_column :roles, :commit, :boolean
    change_column :roles, :export, :boolean
    change_column :roles, :check, :boolean
    change_column :roles, :modify, :boolean
    change_column :roles, :admin, :boolean
  end
end
