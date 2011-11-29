class AddTemplateIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :template_id, :integer
  end
end
