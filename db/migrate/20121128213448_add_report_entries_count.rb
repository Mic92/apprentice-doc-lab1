class AddReportEntriesCount < ActiveRecord::Migration
  def up
    add_column :reports, :report_entries_count, :integer, :default => 0
    Report.reset_column_information
    Report.find(:all).each do |p|
      p.update_attribute :report_entries_count, p.report_entries.length
    end      
  end

  def down
    remove_column :reports, :report_entries_count
  end
end
