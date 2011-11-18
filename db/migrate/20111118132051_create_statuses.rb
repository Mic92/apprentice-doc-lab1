class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.references :report
      t.integer :stype
      t.datetime :date
      t.text :comment

      t.timestamps
    end
    add_index :statuses, :report_id
  end
end
