class AddTrainingbeginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trainingbegin, :date
  end
end
