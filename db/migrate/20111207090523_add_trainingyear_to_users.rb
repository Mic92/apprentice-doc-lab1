class AddTrainingyearToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trainingyear, :integer
  end
end
