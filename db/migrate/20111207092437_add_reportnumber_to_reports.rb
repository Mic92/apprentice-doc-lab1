class AddReportnumberToReports < ActiveRecord::Migration
  def change
    add_column :reports, :reportnumber, :integer
  end
end
