class ReportEntry < ActiveRecord::Base
  attr_accessible :date, :duration_in_hours, :text
  belongs_to :report
end
