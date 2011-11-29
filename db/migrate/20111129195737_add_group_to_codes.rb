class AddGroupToCodes < ActiveRecord::Migration
  def change
    add_column :codes, :codegroup, :integer
  end
end
