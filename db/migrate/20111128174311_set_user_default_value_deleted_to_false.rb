class SetUserDefaultValueDeletedToFalse < ActiveRecord::Migration
  def up
    change_column :users, :deleted, :boolean, :default => false
  end

  def down
    change_column :users, :deleted, :boolean
  end
end
