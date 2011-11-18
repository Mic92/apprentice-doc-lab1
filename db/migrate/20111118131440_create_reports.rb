class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.date :period_start
      t.date :period_end
      t.references :user

      t.timestamps
    end
    add_index :reports, :user_id
  end
end
