class CreateReportEntries < ActiveRecord::Migration
  def change
    create_table :report_entries do |t|
      t.references :report
      t.datetime :date
      t.float :duration_in_hours
      t.text :text

      t.timestamps
    end
    add_index :report_entries, :report_id
  end
end
