class AddNameToCodes < ActiveRecord::Migration
  def change
    add_column :codes, :name, :string
  end
end
