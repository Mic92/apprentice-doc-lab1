class ReportEntry < ActiveRecord::Base
  attr_accessible :date, :duration_in_hours, :text

  belongs_to :report

  validates :report_id, :presence => true
  validates :date, :presence => true
  validates :duration_in_hours, :presence => true, :numericality => { :greater_than => 0 }
  validates :text, :presence => true
end
