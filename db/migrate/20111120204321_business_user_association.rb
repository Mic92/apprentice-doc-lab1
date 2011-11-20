class BusinessUserAssociation < ActiveRecord::Migration
  def up
    add_column :users, :business_id, :integer
    add_index :users, :business_id
  end

  def down
    remove_column :users, :business_id
  end
end
